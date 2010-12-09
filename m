Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab0LIQlM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 11:41:12 -0500
Received: from mail-px0-f179.google.com ([209.85.212.179]:32955 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355Ab0LIQlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 11:41:06 -0500
X-Greylist: delayed 127330 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Dec 2010 11:41:06 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=uVf4MDhJAV8Rvka8Ctzed54at2+UCcNGLDj4QgwyAxcxQ/Jgu3mPRSPZ669CyTr5iA
         dQ72SYToO1ApGLKSgWZ1DYpCy5rAVfMIp1o2R1uyuWux5FCaIpAllfu1QQy7JEitrjRN
         Mq/pNZwwPfVaTHE0kCtYC7nzpdUGUjULX8F1g=
From: Namhyung Kim <namhyung@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] Staging: rtl8192e: use DEFINE_PCI_DEVICE_TABLE
Date: Fri, 10 Dec 2010 01:40:27 +0900
Message-Id: <1291912830-13151-4-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.3.400.g93cef
In-Reply-To: <1291912830-13151-1-git-send-email-namhyung@gmail.com>
References: <1291912830-13151-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert 'const struct pci_device_id xxx[]' to 'DEFINE_PCI_DEVICE_TABLE(xxx)'.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/staging/rtl8192e/r8192E_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rtl8192e/r8192E_core.c b/drivers/staging/rtl8192e/r8192E_core.c
index b1786dcac245..832dc4cbde1b 100644
--- a/drivers/staging/rtl8192e/r8192E_core.c
+++ b/drivers/staging/rtl8192e/r8192E_core.c
@@ -89,7 +89,7 @@ u32 rt_global_debug_component =
                         // 	COMP_INTR       |
 				COMP_ERR ; //always open err flags on
 
-static const struct pci_device_id rtl8192_pci_id_tbl[] __devinitdata = {
+static DEFINE_PCI_DEVICE_TABLE(rtl8192_pci_id_tbl) = {
 #ifdef RTL8190P
 	/* Realtek */
 	/* Dlink */
-- 
1.7.3.3.400.g93cef

