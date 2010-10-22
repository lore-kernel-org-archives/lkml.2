Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab0JVHFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 03:05:55 -0400
Received: from bunsen.bytemark.co.uk ([80.68.81.6]:38531 "EHLO
	bunsen.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab0JVHFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 03:05:51 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Greg KH <greg@kroah.com>
Cc: Martyn Welch <martyn.welch@ge.com>, LKML <linux-kernel@vger.kernel.org>,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>
Subject: [PATCH 11/30] staging/vme/tsi148: declare static functions as such
Date: Fri, 22 Oct 2010 02:36:33 -0400
Message-Id: <1287729412-24356-12-git-send-email-cota@braap.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1287729412-24356-1-git-send-email-cota@braap.org>
References: <1287729412-24356-1-git-send-email-cota@braap.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio G. Cota <cota@braap.org>

Signed-off-by: Emilio G. Cota <cota@braap.org>
---
 drivers/staging/vme/bridges/vme_tsi148.c |   38 +++++++++++++++---------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
index c08927e..3ef5f48 100644
--- a/drivers/staging/vme/bridges/vme_tsi148.c
+++ b/drivers/staging/vme/bridges/vme_tsi148.c
@@ -392,7 +392,7 @@ static void tsi148_irq_exit(struct vme_bridge *tsi148_bridge, struct pci_dev *pd
 /*
  * Check to see if an IACk has been received, return true (1) or false (0).
  */
-int tsi148_iack_received(struct tsi148_driver *bridge)
+static int tsi148_iack_received(struct tsi148_driver *bridge)
 {
 	u32 tmp;
 
@@ -407,7 +407,7 @@ int tsi148_iack_received(struct tsi148_driver *bridge)
 /*
  * Configure VME interrupt
  */
-void tsi148_irq_set(struct vme_bridge *tsi148_bridge, int level,
+static void tsi148_irq_set(struct vme_bridge *tsi148_bridge, int level,
 	int state, int sync)
 {
 	struct pci_dev *pdev;
@@ -447,7 +447,7 @@ void tsi148_irq_set(struct vme_bridge *tsi148_bridge, int level,
  * Generate a VME bus interrupt at the requested level & vector. Wait for
  * interrupt to be acked.
  */
-int tsi148_irq_generate(struct vme_bridge *tsi148_bridge, int level, int statid)
+static int tsi148_irq_generate(struct vme_bridge *tsi148_bridge, int level, int statid)
 {
 	u32 tmp;
 	struct tsi148_driver *bridge;
@@ -547,7 +547,7 @@ static void tsi148_clear_errors(struct vme_bridge *tsi148_bridge,
 /*
  * Initialize a slave window with the requested attributes.
  */
-int tsi148_slave_set(struct vme_slave_resource *image, int enabled,
+static int tsi148_slave_set(struct vme_slave_resource *image, int enabled,
 	unsigned long long vme_base, unsigned long long size,
 	dma_addr_t pci_base, vme_address_t aspace, vme_cycle_t cycle)
 {
@@ -697,7 +697,7 @@ int tsi148_slave_set(struct vme_slave_resource *image, int enabled,
 /*
  * Get slave window configuration.
  */
-int tsi148_slave_get(struct vme_slave_resource *image, int *enabled,
+static int tsi148_slave_get(struct vme_slave_resource *image, int *enabled,
 	unsigned long long *vme_base, unsigned long long *size,
 	dma_addr_t *pci_base, vme_address_t *aspace, vme_cycle_t *cycle)
 {
@@ -893,7 +893,7 @@ static void tsi148_free_resource(struct vme_master_resource *image)
 /*
  * Set the attributes of an outbound window.
  */
-int tsi148_master_set(struct vme_master_resource *image, int enabled,
+static int tsi148_master_set(struct vme_master_resource *image, int enabled,
 	unsigned long long vme_base, unsigned long long size,
 	vme_address_t aspace, vme_cycle_t cycle, vme_width_t dwidth)
 {
@@ -1129,7 +1129,7 @@ err_window:
  *
  * XXX Not parsing prefetch information.
  */
-int __tsi148_master_get(struct vme_master_resource *image, int *enabled,
+static int __tsi148_master_get(struct vme_master_resource *image, int *enabled,
 	unsigned long long *vme_base, unsigned long long *size,
 	vme_address_t *aspace, vme_cycle_t *cycle, vme_width_t *dwidth)
 {
@@ -1239,7 +1239,7 @@ int __tsi148_master_get(struct vme_master_resource *image, int *enabled,
 }
 
 
-int tsi148_master_get(struct vme_master_resource *image, int *enabled,
+static int tsi148_master_get(struct vme_master_resource *image, int *enabled,
 	unsigned long long *vme_base, unsigned long long *size,
 	vme_address_t *aspace, vme_cycle_t *cycle, vme_width_t *dwidth)
 {
@@ -1255,7 +1255,7 @@ int tsi148_master_get(struct vme_master_resource *image, int *enabled,
 	return retval;
 }
 
-ssize_t tsi148_master_read(struct vme_master_resource *image, void *buf,
+static ssize_t tsi148_master_read(struct vme_master_resource *image, void *buf,
 	size_t count, loff_t offset)
 {
 	int retval, enabled;
@@ -1297,7 +1297,7 @@ skip_chk:
 }
 
 
-ssize_t tsi148_master_write(struct vme_master_resource *image, void *buf,
+static ssize_t tsi148_master_write(struct vme_master_resource *image, void *buf,
 	size_t count, loff_t offset)
 {
 	int retval = 0, enabled;
@@ -1364,7 +1364,7 @@ skip_chk:
  *
  * Requires a previously configured master window, returns final value.
  */
-unsigned int tsi148_master_rmw(struct vme_master_resource *image,
+static unsigned int tsi148_master_rmw(struct vme_master_resource *image,
 	unsigned int mask, unsigned int compare, unsigned int swap,
 	loff_t offset)
 {
@@ -1611,7 +1611,7 @@ static int tsi148_dma_set_vme_dest_attributes(struct device *dev, u32 *attr,
 /*
  * Add a link list descriptor to the list
  */
-int tsi148_dma_list_add(struct vme_dma_list *list, struct vme_dma_attr *src,
+static int tsi148_dma_list_add(struct vme_dma_list *list, struct vme_dma_attr *src,
 	struct vme_dma_attr *dest, size_t count)
 {
 	struct tsi148_dma_entry *entry, *prev;
@@ -1784,7 +1784,7 @@ static int tsi148_dma_busy(struct vme_bridge *tsi148_bridge, int channel)
  *
  * XXX Need to provide control register configuration.
  */
-int tsi148_dma_list_exec(struct vme_dma_list *list)
+static int tsi148_dma_list_exec(struct vme_dma_list *list)
 {
 	struct vme_dma_resource *ctrlr;
 	int channel, retval = 0;
@@ -1864,7 +1864,7 @@ int tsi148_dma_list_exec(struct vme_dma_list *list)
  *
  * We have a separate function, don't assume that the chain can't be reused.
  */
-int tsi148_dma_list_empty(struct vme_dma_list *list)
+static int tsi148_dma_list_empty(struct vme_dma_list *list)
 {
 	struct list_head *pos, *temp;
 	struct tsi148_dma_entry *entry;
@@ -1886,7 +1886,7 @@ int tsi148_dma_list_empty(struct vme_dma_list *list)
  * This does not enable the LM monitor - that should be done when the first
  * callback is attached and disabled when the last callback is removed.
  */
-int tsi148_lm_set(struct vme_lm_resource *lm, unsigned long long lm_base,
+static int tsi148_lm_set(struct vme_lm_resource *lm, unsigned long long lm_base,
 	vme_address_t aspace, vme_cycle_t cycle)
 {
 	u32 lm_base_high, lm_base_low, lm_ctl = 0;
@@ -1953,7 +1953,7 @@ int tsi148_lm_set(struct vme_lm_resource *lm, unsigned long long lm_base,
 /* Get configuration of the callback monitor and return whether it is enabled
  * or disabled.
  */
-int tsi148_lm_get(struct vme_lm_resource *lm, unsigned long long *lm_base,
+static int tsi148_lm_get(struct vme_lm_resource *lm, unsigned long long *lm_base,
 	vme_address_t *aspace, vme_cycle_t *cycle)
 {
 	u32 lm_base_high, lm_base_low, lm_ctl, enabled = 0;
@@ -2004,7 +2004,7 @@ int tsi148_lm_get(struct vme_lm_resource *lm, unsigned long long *lm_base,
  *
  * Callback will be passed the monitor triggered.
  */
-int tsi148_lm_attach(struct vme_lm_resource *lm, int monitor,
+static int tsi148_lm_attach(struct vme_lm_resource *lm, int monitor,
 	void (*callback)(int))
 {
 	u32 lm_ctl, tmp;
@@ -2059,7 +2059,7 @@ int tsi148_lm_attach(struct vme_lm_resource *lm, int monitor,
 /*
  * Detach a callback function forn a specific location monitor.
  */
-int tsi148_lm_detach(struct vme_lm_resource *lm, int monitor)
+static int tsi148_lm_detach(struct vme_lm_resource *lm, int monitor)
 {
 	u32 lm_en, tmp;
 	struct tsi148_driver *bridge;
@@ -2099,7 +2099,7 @@ int tsi148_lm_detach(struct vme_lm_resource *lm, int monitor)
 /*
  * Determine Geographical Addressing
  */
-int tsi148_slot_get(struct vme_bridge *tsi148_bridge)
+static int tsi148_slot_get(struct vme_bridge *tsi148_bridge)
 {
 	u32 slot = 0;
 	struct tsi148_driver *bridge;
-- 
1.7.1

