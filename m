Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260Ab0KLLPM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 06:15:12 -0500
Received: from exprod5og104.obsmtp.com ([64.18.0.178]:45468 "EHLO
	exprod5og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757426Ab0KLLPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 06:15:10 -0500
Subject: [PATCH 10/17] staging/vme/ca91cx42: declare static functions as such
To: Greg KH <greg@kroah.com>
From: Martyn Welch <martyn.welch@ge.com>
Cc: devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        "Emilio G. Cota" <cota@braap.org>, LKML <linux-kernel@vger.kernel.org>,
        Bill Pemberton <wfp5p@virginia.edu>
Date: Fri, 12 Nov 2010 11:15:07 +0000
Message-ID: <20101112111507.11631.91229.stgit@ES-BJ21R4J>
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

 drivers/staging/vme/bridges/vme_ca91cx42.c |   52 ++++++++++++++--------------
 1 files changed, 26 insertions(+), 26 deletions(-)


diff --git a/drivers/staging/vme/bridges/vme_ca91cx42.c b/drivers/staging/vme/bridges/vme_ca91cx42.c
index 1f2089f..3ddc93b 100644
--- a/drivers/staging/vme/bridges/vme_ca91cx42.c
+++ b/drivers/staging/vme/bridges/vme_ca91cx42.c
@@ -259,8 +259,8 @@ static void ca91cx42_irq_exit(struct ca91cx42_driver *bridge,
 /*
  * Set up an VME interrupt
  */
-void ca91cx42_irq_set(struct vme_bridge *ca91cx42_bridge, int level, int state,
-	int sync)
+static void ca91cx42_irq_set(struct vme_bridge *ca91cx42_bridge, int level,
+	int state, int sync)
 
 {
 	struct pci_dev *pdev;
@@ -287,7 +287,7 @@ void ca91cx42_irq_set(struct vme_bridge *ca91cx42_bridge, int level, int state,
 	}
 }
 
-int ca91cx42_irq_generate(struct vme_bridge *ca91cx42_bridge, int level,
+static int ca91cx42_irq_generate(struct vme_bridge *ca91cx42_bridge, int level,
 	int statid)
 {
 	u32 tmp;
@@ -323,7 +323,7 @@ int ca91cx42_irq_generate(struct vme_bridge *ca91cx42_bridge, int level,
 	return 0;
 }
 
-int ca91cx42_slave_set(struct vme_slave_resource *image, int enabled,
+static int ca91cx42_slave_set(struct vme_slave_resource *image, int enabled,
 	unsigned long long vme_base, unsigned long long size,
 	dma_addr_t pci_base, vme_address_t aspace, vme_cycle_t cycle)
 {
@@ -429,7 +429,7 @@ int ca91cx42_slave_set(struct vme_slave_resource *image, int enabled,
 	return 0;
 }
 
-int ca91cx42_slave_get(struct vme_slave_resource *image, int *enabled,
+static int ca91cx42_slave_get(struct vme_slave_resource *image, int *enabled,
 	unsigned long long *vme_base, unsigned long long *size,
 	dma_addr_t *pci_base, vme_address_t *aspace, vme_cycle_t *cycle)
 {
@@ -584,7 +584,7 @@ static void ca91cx42_free_resource(struct vme_master_resource *image)
 }
 
 
-int ca91cx42_master_set(struct vme_master_resource *image, int enabled,
+static int ca91cx42_master_set(struct vme_master_resource *image, int enabled,
 	unsigned long long vme_base, unsigned long long size,
 	vme_address_t aspace, vme_cycle_t cycle, vme_width_t dwidth)
 {
@@ -741,8 +741,8 @@ err_window:
 	return retval;
 }
 
-int __ca91cx42_master_get(struct vme_master_resource *image, int *enabled,
-	unsigned long long *vme_base, unsigned long long *size,
+static int __ca91cx42_master_get(struct vme_master_resource *image,
+	int *enabled, unsigned long long *vme_base, unsigned long long *size,
 	vme_address_t *aspace, vme_cycle_t *cycle, vme_width_t *dwidth)
 {
 	unsigned int i, ctl;
@@ -828,7 +828,7 @@ int __ca91cx42_master_get(struct vme_master_resource *image, int *enabled,
 	return 0;
 }
 
-int ca91cx42_master_get(struct vme_master_resource *image, int *enabled,
+static int ca91cx42_master_get(struct vme_master_resource *image, int *enabled,
 	unsigned long long *vme_base, unsigned long long *size,
 	vme_address_t *aspace, vme_cycle_t *cycle, vme_width_t *dwidth)
 {
@@ -844,8 +844,8 @@ int ca91cx42_master_get(struct vme_master_resource *image, int *enabled,
 	return retval;
 }
 
-ssize_t ca91cx42_master_read(struct vme_master_resource *image, void *buf,
-	size_t count, loff_t offset)
+static ssize_t ca91cx42_master_read(struct vme_master_resource *image,
+	void *buf, size_t count, loff_t offset)
 {
 	ssize_t retval;
 	void *addr = image->kern_base + offset;
@@ -904,8 +904,8 @@ out:
 	return retval;
 }
 
-ssize_t ca91cx42_master_write(struct vme_master_resource *image, void *buf,
-	size_t count, loff_t offset)
+static ssize_t ca91cx42_master_write(struct vme_master_resource *image,
+	void *buf, size_t count, loff_t offset)
 {
 	ssize_t retval;
 	void *addr = image->kern_base + offset;
@@ -959,7 +959,7 @@ out:
 	return retval;
 }
 
-unsigned int ca91cx42_master_rmw(struct vme_master_resource *image,
+static unsigned int ca91cx42_master_rmw(struct vme_master_resource *image,
 	unsigned int mask, unsigned int compare, unsigned int swap,
 	loff_t offset)
 {
@@ -1015,8 +1015,8 @@ out:
 	return result;
 }
 
-int ca91cx42_dma_list_add(struct vme_dma_list *list, struct vme_dma_attr *src,
-	struct vme_dma_attr *dest, size_t count)
+static int ca91cx42_dma_list_add(struct vme_dma_list *list,
+	struct vme_dma_attr *src, struct vme_dma_attr *dest, size_t count)
 {
 	struct ca91cx42_dma_entry *entry, *prev;
 	struct vme_dma_pci *pci_attr;
@@ -1176,7 +1176,7 @@ static int ca91cx42_dma_busy(struct vme_bridge *ca91cx42_bridge)
 		return 1;
 }
 
-int ca91cx42_dma_list_exec(struct vme_dma_list *list)
+static int ca91cx42_dma_list_exec(struct vme_dma_list *list)
 {
 	struct vme_dma_resource *ctrlr;
 	struct ca91cx42_dma_entry *entry;
@@ -1258,7 +1258,7 @@ int ca91cx42_dma_list_exec(struct vme_dma_list *list)
 
 }
 
-int ca91cx42_dma_list_empty(struct vme_dma_list *list)
+static int ca91cx42_dma_list_empty(struct vme_dma_list *list)
 {
 	struct list_head *pos, *temp;
 	struct ca91cx42_dma_entry *entry;
@@ -1280,8 +1280,8 @@ int ca91cx42_dma_list_empty(struct vme_dma_list *list)
  * This does not enable the LM monitor - that should be done when the first
  * callback is attached and disabled when the last callback is removed.
  */
-int ca91cx42_lm_set(struct vme_lm_resource *lm, unsigned long long lm_base,
-	vme_address_t aspace, vme_cycle_t cycle)
+static int ca91cx42_lm_set(struct vme_lm_resource *lm,
+	unsigned long long lm_base, vme_address_t aspace, vme_cycle_t cycle)
 {
 	u32 temp_base, lm_ctl = 0;
 	int i;
@@ -1348,8 +1348,8 @@ int ca91cx42_lm_set(struct vme_lm_resource *lm, unsigned long long lm_base,
 /* Get configuration of the callback monitor and return whether it is enabled
  * or disabled.
  */
-int ca91cx42_lm_get(struct vme_lm_resource *lm, unsigned long long *lm_base,
-	vme_address_t *aspace, vme_cycle_t *cycle)
+static int ca91cx42_lm_get(struct vme_lm_resource *lm,
+	unsigned long long *lm_base, vme_address_t *aspace, vme_cycle_t *cycle)
 {
 	u32 lm_ctl, enabled = 0;
 	struct ca91cx42_driver *bridge;
@@ -1391,7 +1391,7 @@ int ca91cx42_lm_get(struct vme_lm_resource *lm, unsigned long long *lm_base,
  *
  * Callback will be passed the monitor triggered.
  */
-int ca91cx42_lm_attach(struct vme_lm_resource *lm, int monitor,
+static int ca91cx42_lm_attach(struct vme_lm_resource *lm, int monitor,
 	void (*callback)(int))
 {
 	u32 lm_ctl, tmp;
@@ -1440,7 +1440,7 @@ int ca91cx42_lm_attach(struct vme_lm_resource *lm, int monitor,
 /*
  * Detach a callback function forn a specific location monitor.
  */
-int ca91cx42_lm_detach(struct vme_lm_resource *lm, int monitor)
+static int ca91cx42_lm_detach(struct vme_lm_resource *lm, int monitor)
 {
 	u32 tmp;
 	struct ca91cx42_driver *bridge;
@@ -1473,7 +1473,7 @@ int ca91cx42_lm_detach(struct vme_lm_resource *lm, int monitor)
 	return 0;
 }
 
-int ca91cx42_slot_get(struct vme_bridge *ca91cx42_bridge)
+static int ca91cx42_slot_get(struct vme_bridge *ca91cx42_bridge)
 {
 	u32 slot = 0;
 	struct ca91cx42_driver *bridge;
@@ -1832,7 +1832,7 @@ err_struct:
 
 }
 
-void ca91cx42_remove(struct pci_dev *pdev)
+static void ca91cx42_remove(struct pci_dev *pdev)
 {
 	struct list_head *pos = NULL;
 	struct vme_master_resource *master_image;


--
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square, Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
