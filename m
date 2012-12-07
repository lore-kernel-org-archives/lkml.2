Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945972Ab2LGGZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 01:25:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017Ab2LGGZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 01:25:16 -0500
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 02/15] PCI/acpiphp: Fix coding style of external declarations
	in acpiphp.h
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, yinghai@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 06 Dec 2012 23:25:06 -0700
Message-ID: <20121207062505.11051.63536.stgit@amt.stowe>
In-Reply-To: <20121207062454.11051.12739.stgit@amt.stowe>
References: <20121207062454.11051.12739.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The external declarations trigger warnings from ./scripts/checkpatch.pl
such as:
  WARNING: space prohibited between function name and open parenthesis '('
  #32: FILE: drivers/pci/hotplug/acpiphp.h:194:
  +extern void acpiphp_glue_init (void);

This patch removes the extraneous spaces between the function names and
open parenthesis '('.

No functional change.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 drivers/pci/hotplug/acpiphp.h |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp.h b/drivers/pci/hotplug/acpiphp.h
index a1afb5b..014ae78 100644
--- a/drivers/pci/hotplug/acpiphp.h
+++ b/drivers/pci/hotplug/acpiphp.h
@@ -191,18 +191,18 @@ extern int acpiphp_register_hotplug_slot(struct acpiphp_slot *slot);
 extern void acpiphp_unregister_hotplug_slot(struct acpiphp_slot *slot);
 
 /* acpiphp_glue.c */
-extern int acpiphp_glue_init (void);
-extern void acpiphp_glue_exit (void);
-extern int acpiphp_get_num_slots (void);
+extern int acpiphp_glue_init(void);
+extern void acpiphp_glue_exit(void);
+extern int acpiphp_get_num_slots(void);
 typedef int (*acpiphp_callback)(struct acpiphp_slot *slot, void *data);
 
-extern int acpiphp_enable_slot (struct acpiphp_slot *slot);
-extern int acpiphp_disable_slot (struct acpiphp_slot *slot);
-extern int acpiphp_eject_slot (struct acpiphp_slot *slot);
-extern u8 acpiphp_get_power_status (struct acpiphp_slot *slot);
-extern u8 acpiphp_get_attention_status (struct acpiphp_slot *slot);
-extern u8 acpiphp_get_latch_status (struct acpiphp_slot *slot);
-extern u8 acpiphp_get_adapter_status (struct acpiphp_slot *slot);
+extern int acpiphp_enable_slot(struct acpiphp_slot *slot);
+extern int acpiphp_disable_slot(struct acpiphp_slot *slot);
+extern int acpiphp_eject_slot(struct acpiphp_slot *slot);
+extern u8 acpiphp_get_power_status(struct acpiphp_slot *slot);
+extern u8 acpiphp_get_attention_status(struct acpiphp_slot *slot);
+extern u8 acpiphp_get_latch_status(struct acpiphp_slot *slot);
+extern u8 acpiphp_get_adapter_status(struct acpiphp_slot *slot);
 
 /* variables */
 extern bool acpiphp_debug;

