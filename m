Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242Ab0KLLPI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 06:15:08 -0500
Received: from exprod5og105.obsmtp.com ([64.18.0.180]:45954 "EHLO
	exprod5og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757062Ab0KLLPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 06:15:04 -0500
Subject: [PATCH 09/17] staging/vme/tsi148: declare static functions as such
To: Greg KH <greg@kroah.com>
From: Martyn Welch <martyn.welch@ge.com>
Cc: devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        "Emilio G. Cota" <cota@braap.org>, LKML <linux-kernel@vger.kernel.org>,
        Bill Pemberton <wfp5p@virginia.edu>
Date: Fri, 12 Nov 2010 11:15:00 +0000
Message-ID: <20101112111500.11631.46055.stgit@ES-BJ21R4J>
In-Reply-To: <20101112111359.11631.84086.stgit@ES-BJ21R4J>
References: <20101112111359.11631.84086.stgit@ES-BJ21R4J>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio G. Cota <cota@braap.org>

Signed-off-by: Emilio G. Cota <cota@braap.org>
[martyn.welch@ge.com: modified to remove checkpatch warnings]
Signed-off-by: Martyn Welch <martyn.welch@ge.com>
---

 drivers/staging/vme/bridges/vme_tsi148.c |   43 +++++++++++++++---------------
 1 files changed, 22 insertions(+), 21 deletions(-)


diff --git a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
index e79a5fa..9550b4a 100644
--- a/drivers/staging/vme/bridges/vme_tsi148.c
+++ b/drivers/staging/vme/bridges/vme_tsi148.c
@@ -393,7 +393,7 @@ static void tsi148_irq_exit(struct vme_bridge *tsi148_bridge,
 /*
  * Check to see if an IACk has been received, return true (1) or false (0).
  */
-int tsi148_iack_received(struct tsi148_driver *bridge)
+static int tsi148_iack_received(struct tsi148_driver *bridge)
 {
 	u32 tmp;
 
@@ -408,7 +408,7 @@ int tsi148_iack_received(struct tsi148_driver *bridge)
 /*
  * Configure VME interrupt
  */
-void tsi148_irq_set(struct vme_bridge *tsi148_bridge, int level,
+static void tsi148_irq_set(struct vme_bridge *tsi148_bridge, int level,
 	int state, int sync)
 {
 	struct pci_dev *pdev;
@@ -448,7 +448,8 @@ void tsi148_irq_set(struct vme_bridge *tsi148_bridge, int level,
  * Generate a VME bus interrupt at the requested level & vector. Wait for
  * interrupt to be acked.
  */
-int tsi148_irq_generate(struct vme_bridge *tsi148_bridge, int level, int statid)
+static int tsi148_irq_generate(struct vme_bridge *tsi148_bridge, int level,
+	int statid)
 {
 	u32 tmp;
 	struct tsi148_driver *bridge;
@@ -548,7 +549,7 @@ static void tsi148_clear_errors(struct vme_bridge *tsi148_bridge,
 /*
  * Initialize a slave window with the requested attributes.
  */
-int tsi148_slave_set(struct vme_slave_resource *image, int enabled,
+static int tsi148_slave_set(struct vme_slave_resource *image, int enabled,
 	unsigned long long vme_base, unsigned long long size,
 	dma_addr_t pci_base, vme_address_t aspace, vme_cycle_t cycle)
 {
@@ -698,7 +699,7 @@ int tsi148_slave_set(struct vme_slave_resource *image, int enabled,
 /*
  * Get slave window configuration.
  */
-int tsi148_slave_get(struct vme_slave_resource *image, int *enabled,
+static int tsi148_slave_get(struct vme_slave_resource *image, int *enabled,
 	unsigned long long *vme_base, unsigned long long *size,
 	dma_addr_t *pci_base, vme_address_t *aspace, vme_cycle_t *cycle)
 {
@@ -894,7 +895,7 @@ static void tsi148_free_resource(struct vme_master_resource *image)
 /*
  * Set the attributes of an outbound window.
  */
-int tsi148_master_set(struct vme_master_resource *image, int enabled,
+static int tsi148_master_set(struct vme_master_resource *image, int enabled,
 	unsigned long long vme_base, unsigned long long size,
 	vme_address_t aspace, vme_cycle_t cycle, vme_width_t dwidth)
 {
@@ -1130,7 +1131,7 @@ err_window:
  *
  * XXX Not parsing prefetch information.
  */
-int __tsi148_master_get(struct vme_master_resource *image, int *enabled,
+static int __tsi148_master_get(struct vme_master_resource *image, int *enabled,
 	unsigned long long *vme_base, unsigned long long *size,
 	vme_address_t *aspace, vme_cycle_t *cycle, vme_width_t *dwidth)
 {
@@ -1240,7 +1241,7 @@ int __tsi148_master_get(struct vme_master_resource *image, int *enabled,
 }
 
 
-int tsi148_master_get(struct vme_master_resource *image, int *enabled,
+static int tsi148_master_get(struct vme_master_resource *image, int *enabled,
 	unsigned long long *vme_base, unsigned long long *size,
 	vme_address_t *aspace, vme_cycle_t *cycle, vme_width_t *dwidth)
 {
@@ -1256,7 +1257,7 @@ int tsi148_master_get(struct vme_master_resource *image, int *enabled,
 	return retval;
 }
 
-ssize_t tsi148_master_read(struct vme_master_resource *image, void *buf,
+static ssize_t tsi148_master_read(struct vme_master_resource *image, void *buf,
 	size_t count, loff_t offset)
 {
 	int retval, enabled;
@@ -1298,7 +1299,7 @@ skip_chk:
 }
 
 
-ssize_t tsi148_master_write(struct vme_master_resource *image, void *buf,
+static ssize_t tsi148_master_write(struct vme_master_resource *image, void *buf,
 	size_t count, loff_t offset)
 {
 	int retval = 0, enabled;
@@ -1365,7 +1366,7 @@ skip_chk:
  *
  * Requires a previously configured master window, returns final value.
  */
-unsigned int tsi148_master_rmw(struct vme_master_resource *image,
+static unsigned int tsi148_master_rmw(struct vme_master_resource *image,
 	unsigned int mask, unsigned int compare, unsigned int swap,
 	loff_t offset)
 {
@@ -1612,8 +1613,8 @@ static int tsi148_dma_set_vme_dest_attributes(struct device *dev, u32 *attr,
 /*
  * Add a link list descriptor to the list
  */
-int tsi148_dma_list_add(struct vme_dma_list *list, struct vme_dma_attr *src,
-	struct vme_dma_attr *dest, size_t count)
+static int tsi148_dma_list_add(struct vme_dma_list *list,
+	struct vme_dma_attr *src, struct vme_dma_attr *dest, size_t count)
 {
 	struct tsi148_dma_entry *entry, *prev;
 	u32 address_high, address_low;
@@ -1785,7 +1786,7 @@ static int tsi148_dma_busy(struct vme_bridge *tsi148_bridge, int channel)
  *
  * XXX Need to provide control register configuration.
  */
-int tsi148_dma_list_exec(struct vme_dma_list *list)
+static int tsi148_dma_list_exec(struct vme_dma_list *list)
 {
 	struct vme_dma_resource *ctrlr;
 	int channel, retval = 0;
@@ -1865,7 +1866,7 @@ int tsi148_dma_list_exec(struct vme_dma_list *list)
  *
  * We have a separate function, don't assume that the chain can't be reused.
  */
-int tsi148_dma_list_empty(struct vme_dma_list *list)
+static int tsi148_dma_list_empty(struct vme_dma_list *list)
 {
 	struct list_head *pos, *temp;
 	struct tsi148_dma_entry *entry;
@@ -1887,7 +1888,7 @@ int tsi148_dma_list_empty(struct vme_dma_list *list)
  * This does not enable the LM monitor - that should be done when the first
  * callback is attached and disabled when the last callback is removed.
  */
-int tsi148_lm_set(struct vme_lm_resource *lm, unsigned long long lm_base,
+static int tsi148_lm_set(struct vme_lm_resource *lm, unsigned long long lm_base,
 	vme_address_t aspace, vme_cycle_t cycle)
 {
 	u32 lm_base_high, lm_base_low, lm_ctl = 0;
@@ -1954,8 +1955,8 @@ int tsi148_lm_set(struct vme_lm_resource *lm, unsigned long long lm_base,
 /* Get configuration of the callback monitor and return whether it is enabled
  * or disabled.
  */
-int tsi148_lm_get(struct vme_lm_resource *lm, unsigned long long *lm_base,
-	vme_address_t *aspace, vme_cycle_t *cycle)
+static int tsi148_lm_get(struct vme_lm_resource *lm,
+	unsigned long long *lm_base, vme_address_t *aspace, vme_cycle_t *cycle)
 {
 	u32 lm_base_high, lm_base_low, lm_ctl, enabled = 0;
 	struct tsi148_driver *bridge;
@@ -2005,7 +2006,7 @@ int tsi148_lm_get(struct vme_lm_resource *lm, unsigned long long *lm_base,
  *
  * Callback will be passed the monitor triggered.
  */
-int tsi148_lm_attach(struct vme_lm_resource *lm, int monitor,
+static int tsi148_lm_attach(struct vme_lm_resource *lm, int monitor,
 	void (*callback)(int))
 {
 	u32 lm_ctl, tmp;
@@ -2060,7 +2061,7 @@ int tsi148_lm_attach(struct vme_lm_resource *lm, int monitor,
 /*
  * Detach a callback function forn a specific location monitor.
  */
-int tsi148_lm_detach(struct vme_lm_resource *lm, int monitor)
+static int tsi148_lm_detach(struct vme_lm_resource *lm, int monitor)
 {
 	u32 lm_en, tmp;
 	struct tsi148_driver *bridge;
@@ -2100,7 +2101,7 @@ int tsi148_lm_detach(struct vme_lm_resource *lm, int monitor)
 /*
  * Determine Geographical Addressing
  */
-int tsi148_slot_get(struct vme_bridge *tsi148_bridge)
+static int tsi148_slot_get(struct vme_bridge *tsi148_bridge)
 {
 	u32 slot = 0;
 	struct tsi148_driver *bridge;


--
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square, Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
