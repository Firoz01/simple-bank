
postgres:
	docker run --name postgres15 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=abcd1234 -d postgres:15-alpine

createdb:
	docker exec -it postgres15 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres15 dropdb simple_bank	
migrateup:
	migrate -database postgres://root:abcd1234@localhost:5432/simple_bank?sslmode=disable  -path db/migrations -verbose up 
migratedown:
	migrate -database postgres://root:abcd1234@localhost:5432/simple_bank?sslmode=disable  -path db/migrations -verbose down 
sqlc:
	docker run --rm -v "%cd%:/src" -w /src kjconroy/sqlc generate
test:
	go test -v -cover ./...

server:
	go run main.go
.PHONY:
	postgres createdb dropdb migrateup migratedown server
	