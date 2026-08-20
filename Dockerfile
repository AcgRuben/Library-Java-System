FROM eclipse-temurin:17-jdk-alpine AS build
WORKDIR /app
COPY library-system/ .
RUN chmod +x mvnw || true
RUN ./mvnw clean package -DskipTests

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
ENV PORT=8080
COPY --from=build /app/target/*.jar app.jar
COPY --from=build /app/library.db library.db
EXPOSE 8080
CMD ["sh", "-c", "java -Dserver.port=${PORT:-8080} -jar app.jar"]
