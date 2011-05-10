Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953Ab1EJQUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 12:20:37 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:41236 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932828Ab1EJQUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 12:20:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:user-agent:mime-version
         :content-type;
        b=EcRVn5/zuakISUTuwwYbo+ozwsFdlArfGWlRYzkW6V2pqHQOkasVKhIHCYuYIU0q53
         voJWroubw0cxhvlyp3tQdkxYW+HPMznXEZ7KJdWwyILWRwGuMhh8BRW4fF8j3uj5VSI8
         zJ4GWT3Huk4tiJ6OFoHKha8sUYhdb3it0+MwI=
Date: Tue, 10 May 2011 13:22:15 -0300 (BRT)
From: Marcos <marcos.mage@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] include: linux: pnp.h: Fix identation issue
Message-ID: <4dc965d3.23bfec0a.343e.fffff0a7@mx.google.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d066854271f11c7fa0fc39ae86724cdd3b340153 Mon Sep 17 00:00:00 2001
From: marcos-paulo <marcos.mage@gmail.com>
Date: Tue, 10 May 2011 12:11:48 -0300
Subject: [PATCH] include: linux: pnp.h: Fix identation issue

Fix some identation issue on formal parameter of functions

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
---
 include/linux/pnp.h |   94 +++++++++++++++++++++++++++++++-------------------
 1 files changed, 58 insertions(+), 36 deletions(-)

diff --git a/include/linux/pnp.h b/include/linux/pnp.h
index 1bc1338..75ca306 100644
--- a/include/linux/pnp.h
+++ b/include/linux/pnp.h
@@ -22,11 +22,13 @@ struct pnp_dev;
  * Resource Management
  */
 #ifdef CONFIG_PNP
-struct resource *pnp_get_resource(struct pnp_dev *dev, unsigned long type,
-				unsigned int num);
+struct resource *pnp_get_resource(struct pnp_dev *dev,
+				  unsigned long type,
+				  unsigned int num);
 #else
 static inline struct resource *pnp_get_resource(struct pnp_dev *dev,
-			unsigned long type, unsigned int num)
+						unsigned long type,
+						unsigned int num)
 {
 	return NULL;
 }
@@ -84,7 +86,8 @@ static inline unsigned long pnp_port_flags(struct pnp_dev *dev,
 	return IORESOURCE_IO | IORESOURCE_AUTO;
 }
 
-static inline int pnp_port_valid(struct pnp_dev *dev, unsigned int bar)
+static inline int pnp_port_valid(struct pnp_dev *dev,
+				 unsigned int bar)
 {
 	return pnp_resource_valid(pnp_get_resource(dev, IORESOURCE_IO, bar));
 }
@@ -120,7 +123,8 @@ static inline resource_size_t pnp_mem_end(struct pnp_dev *dev,
 	return 0;
 }
 
-static inline unsigned long pnp_mem_flags(struct pnp_dev *dev, unsigned int bar)
+static inline unsigned long pnp_mem_flags(struct pnp_dev *dev,
+					  unsigned int bar)
 {
 	struct resource *res = pnp_get_resource(dev, IORESOURCE_MEM, bar);
 
@@ -129,7 +133,8 @@ static inline unsigned long pnp_mem_flags(struct pnp_dev *dev, unsigned int bar)
 	return IORESOURCE_MEM | IORESOURCE_AUTO;
 }
 
-static inline int pnp_mem_valid(struct pnp_dev *dev, unsigned int bar)
+static inline int pnp_mem_valid(struct pnp_dev *dev,
+				unsigned int bar)
 {
 	return pnp_resource_valid(pnp_get_resource(dev, IORESOURCE_MEM, bar));
 }
@@ -145,7 +150,8 @@ static inline resource_size_t pnp_mem_len(struct pnp_dev *dev,
 }
 
 
-static inline resource_size_t pnp_irq(struct pnp_dev *dev, unsigned int bar)
+static inline resource_size_t pnp_irq(struct pnp_dev *dev,
+				      unsigned int bar)
 {
 	struct resource *res = pnp_get_resource(dev, IORESOURCE_IRQ, bar);
 
@@ -154,7 +160,8 @@ static inline resource_size_t pnp_irq(struct pnp_dev *dev, unsigned int bar)
 	return -1;
 }
 
-static inline unsigned long pnp_irq_flags(struct pnp_dev *dev, unsigned int bar)
+static inline unsigned long pnp_irq_flags(struct pnp_dev *dev,
+					  unsigned int bar)
 {
 	struct resource *res = pnp_get_resource(dev, IORESOURCE_IRQ, bar);
 
@@ -163,13 +170,15 @@ static inline unsigned long pnp_irq_flags(struct pnp_dev *dev, unsigned int bar)
 	return IORESOURCE_IRQ | IORESOURCE_AUTO;
 }
 
-static inline int pnp_irq_valid(struct pnp_dev *dev, unsigned int bar)
+static inline int pnp_irq_valid(struct pnp_dev *dev,
+				unsigned int bar)
 {
 	return pnp_resource_valid(pnp_get_resource(dev, IORESOURCE_IRQ, bar));
 }
 
 
-static inline resource_size_t pnp_dma(struct pnp_dev *dev, unsigned int bar)
+static inline resource_size_t pnp_dma(struct pnp_dev *dev,
+				      unsigned int bar)
 {
 	struct resource *res = pnp_get_resource(dev, IORESOURCE_DMA, bar);
 
@@ -178,7 +187,8 @@ static inline resource_size_t pnp_dma(struct pnp_dev *dev, unsigned int bar)
 	return -1;
 }
 
-static inline unsigned long pnp_dma_flags(struct pnp_dev *dev, unsigned int bar)
+static inline unsigned long pnp_dma_flags(struct pnp_dev *dev,
+					  unsigned int bar)
 {
 	struct resource *res = pnp_get_resource(dev, IORESOURCE_DMA, bar);
 
@@ -187,12 +197,12 @@ static inline unsigned long pnp_dma_flags(struct pnp_dev *dev, unsigned int bar)
 	return IORESOURCE_DMA | IORESOURCE_AUTO;
 }
 
-static inline int pnp_dma_valid(struct pnp_dev *dev, unsigned int bar)
+static inline int pnp_dma_valid(struct pnp_dev *dev,
+				unsigned int bar)
 {
 	return pnp_resource_valid(pnp_get_resource(dev, IORESOURCE_DMA, bar));
 }
 
-
 /*
  * Device Management
  */
@@ -212,14 +222,14 @@ struct pnp_card {
 	unsigned char productver;	/* product version */
 	unsigned int serial;		/* serial number */
 	unsigned char checksum;		/* if zero - checksum passed */
-	struct proc_dir_entry *procdir;	/* directory entry in /proc/bus/isapnp */
+	struct proc_dir_entry *procdir;	/* directory entry in /proc/bus/isapnp*/
 };
 
 #define global_to_pnp_card(n) list_entry(n, struct pnp_card, global_list)
 #define protocol_to_pnp_card(n) list_entry(n, struct pnp_card, protocol_list)
 #define to_pnp_card(n) container_of(n, struct pnp_card, dev)
 #define pnp_for_each_card(card) \
-	for((card) = global_to_pnp_card(pnp_cards.next); \
+	for ((card) = global_to_pnp_card(pnp_cards.next); \
 	(card) != global_to_pnp_card(&pnp_cards); \
 	(card) = global_to_pnp_card((card)->global_list.next))
 
@@ -235,7 +245,8 @@ static inline void *pnp_get_card_drvdata(struct pnp_card_link *pcard)
 	return pcard->driver_data;
 }
 
-static inline void pnp_set_card_drvdata(struct pnp_card_link *pcard, void *data)
+static inline void pnp_set_card_drvdata(struct pnp_card_link *pcard,
+					void *data)
 {
 	pcard->driver_data = data;
 }
@@ -275,28 +286,29 @@ struct pnp_dev {
 #define protocol_to_pnp_dev(n) list_entry(n, struct pnp_dev, protocol_list)
 #define	to_pnp_dev(n) container_of(n, struct pnp_dev, dev)
 #define pnp_for_each_dev(dev) \
-	for((dev) = global_to_pnp_dev(pnp_global.next); \
+	for ((dev) = global_to_pnp_dev(pnp_global.next); \
 	(dev) != global_to_pnp_dev(&pnp_global); \
 	(dev) = global_to_pnp_dev((dev)->global_list.next))
-#define card_for_each_dev(card,dev) \
-	for((dev) = card_to_pnp_dev((card)->devices.next); \
+#define card_for_each_dev(card, dev) \
+	for ((dev) = card_to_pnp_dev((card)->devices.next); \
 	(dev) != card_to_pnp_dev(&(card)->devices); \
 	(dev) = card_to_pnp_dev((dev)->card_list.next))
-#define pnp_dev_name(dev) (dev)->name
+#define pnp_dev_name(dev) ((dev)->name)
 
 static inline void *pnp_get_drvdata(struct pnp_dev *pdev)
 {
 	return dev_get_drvdata(&pdev->dev);
 }
 
-static inline void pnp_set_drvdata(struct pnp_dev *pdev, void *data)
+static inline void pnp_set_drvdata(struct pnp_dev *pdev,
+				   void *data)
 {
 	dev_set_drvdata(&pdev->dev, data);
 }
 
 struct pnp_fixup {
 	char id[7];
-	void (*quirk_function) (struct pnp_dev * dev);	/* fixup function */
+	void (*quirk_function) (struct pnp_dev *dev);	/* fixup function */
 };
 
 /* config parameters */
@@ -415,8 +427,8 @@ struct pnp_protocol {
 
 	/* protocol specific suspend/resume */
 	bool (*can_wakeup) (struct pnp_dev *dev);
-	int (*suspend) (struct pnp_dev * dev, pm_message_t state);
-	int (*resume) (struct pnp_dev * dev);
+	int (*suspend) (struct pnp_dev *dev, pm_message_t state);
+	int (*resume) (struct pnp_dev *dev);
 
 	/* used by pnp layer only (look but don't touch) */
 	unsigned char number;	/* protocol number */
@@ -426,12 +438,12 @@ struct pnp_protocol {
 };
 
 #define to_pnp_protocol(n) list_entry(n, struct pnp_protocol, protocol_list)
-#define protocol_for_each_card(protocol,card) \
-	for((card) = protocol_to_pnp_card((protocol)->cards.next); \
+#define protocol_for_each_card(protocol, card) \
+	for ((card) = protocol_to_pnp_card((protocol)->cards.next); \
 	(card) != protocol_to_pnp_card(&(protocol)->cards); \
 	(card) = protocol_to_pnp_card((card)->protocol_list.next))
-#define protocol_for_each_dev(protocol,dev) \
-	for((dev) = protocol_to_pnp_dev((protocol)->devices.next); \
+#define protocol_for_each_dev(protocol, dev) \
+	for ((dev) = protocol_to_pnp_dev((protocol)->devices.next); \
 	(dev) != protocol_to_pnp_dev(&(protocol)->devices); \
 	(dev) = protocol_to_pnp_dev((dev)->protocol_list.next))
 
@@ -447,25 +459,30 @@ extern int pnp_platform_devices;
 
 /* multidevice card support */
 struct pnp_dev *pnp_request_card_device(struct pnp_card_link *clink,
-					const char *id, struct pnp_dev *from);
+					const char *id,
+					struct pnp_dev *from);
 void pnp_release_card_device(struct pnp_dev *dev);
 int pnp_register_card_driver(struct pnp_card_driver *drv);
 void pnp_unregister_card_driver(struct pnp_card_driver *drv);
 extern struct list_head pnp_cards;
 
 /* resource management */
-int pnp_possible_config(struct pnp_dev *dev, int type, resource_size_t base,
+int pnp_possible_config(struct pnp_dev *dev,
+			int type,
+			resource_size_t base,
 			resource_size_t size);
 int pnp_auto_config_dev(struct pnp_dev *dev);
 int pnp_start_dev(struct pnp_dev *dev);
 int pnp_stop_dev(struct pnp_dev *dev);
 int pnp_activate_dev(struct pnp_dev *dev);
 int pnp_disable_dev(struct pnp_dev *dev);
-int pnp_range_reserved(resource_size_t start, resource_size_t end);
+int pnp_range_reserved(resource_size_t start,
+		       resource_size_t end);
 
 /* protocol helpers */
 int pnp_is_active(struct pnp_dev *dev);
-int compare_pnp_id(struct pnp_id *pos, const char *id);
+int compare_pnp_id(struct pnp_id *pos,
+		   const char *id);
 int pnp_register_driver(struct pnp_driver *drv);
 void pnp_unregister_driver(struct pnp_driver *drv);
 
@@ -478,13 +495,16 @@ static inline void pnp_device_detach(struct pnp_dev *pnp_dev) { }
 #define pnp_platform_devices 0
 
 /* multidevice card support */
-static inline struct pnp_dev *pnp_request_card_device(struct pnp_card_link *clink, const char *id, struct pnp_dev *from) { return NULL; }
+static inline struct pnp_dev *pnp_request_card_device(struct pnp_card_link *clink,
+						      const char *id,
+						      struct pnp_dev *from) { return NULL; }
 static inline void pnp_release_card_device(struct pnp_dev *dev) { }
 static inline int pnp_register_card_driver(struct pnp_card_driver *drv) { return -ENODEV; }
 static inline void pnp_unregister_card_driver(struct pnp_card_driver *drv) { }
 
 /* resource management */
-static inline int pnp_possible_config(struct pnp_dev *dev, int type,
+static inline int pnp_possible_config(struct pnp_dev *dev,
+				      int type,
 				      resource_size_t base,
 				      resource_size_t size) { return 0; }
 static inline int pnp_auto_config_dev(struct pnp_dev *dev) { return -ENODEV; }
@@ -492,11 +512,13 @@ static inline int pnp_start_dev(struct pnp_dev *dev) { return -ENODEV; }
 static inline int pnp_stop_dev(struct pnp_dev *dev) { return -ENODEV; }
 static inline int pnp_activate_dev(struct pnp_dev *dev) { return -ENODEV; }
 static inline int pnp_disable_dev(struct pnp_dev *dev) { return -ENODEV; }
-static inline int pnp_range_reserved(resource_size_t start, resource_size_t end) { return 0;}
+static inline int pnp_range_reserved(resource_size_t start,
+				     resource_size_t end) { return 0; }
 
 /* protocol helpers */
 static inline int pnp_is_active(struct pnp_dev *dev) { return 0; }
-static inline int compare_pnp_id(struct pnp_id *pos, const char *id) { return -ENODEV; }
+static inline int compare_pnp_id(struct pnp_id *pos,
+				 const char *id) { return -ENODEV; }
 static inline int pnp_register_driver(struct pnp_driver *drv) { return -ENODEV; }
 static inline void pnp_unregister_driver(struct pnp_driver *drv) { }
 
-- 
1.7.1

Marcos Paulo de Souza
[Sent for my Alpine Client]
