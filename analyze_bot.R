library(jsonlite)
library(dplyr)

setwd("~/PokemonGo-Bot/")
raw.dat <- readLines("./data/pokemon.json")
pokemon.dat <- fromJSON(raw.dat) %>% 
  data.frame(Number = as.numeric(pokemon.dat$Number),
             Name = pokemon.dat$Name,
             Type_I = unlist(pokemon.dat$`Type I`))

# run this to update inventory
raw.dat <- readLines("./web/inventory-user@gmail.com.json")
rd <- fromJSON(raw.dat)
my.dat <- rd$inventory_item_data$pokemon_data %>% tbl_df  # 322 x 21
my.dat <- left_join(my.dat, pokemon.dat, by=c("pokemon_id"="Number"))
# write.csv(my.dat, "rd.csv")

my.dat.bst <- my.dat %>% filter(!is.na(pokemon_id)) %>%
  select(pokemon_id, Name, Type_I, nickname, favorite, from_fort, num_upgrades,
         individual_stamina, individual_attack, individual_defense, cp) %>%
  mutate(potential = individual_stamina + individual_attack + individual_defense ) %>%
  arrange(desc(potential))
my.dat.bst