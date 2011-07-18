Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab1GRNMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 09:12:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902Ab1GRNJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 09:09:16 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, johnpol@2ka.mipt.ru
Subject: [PATCH 29/34] drivers/w1 changes for SMBIOS and System Firmware
Date: Mon, 18 Jul 2011 09:08:43 -0400
Message-Id: <1310994528-26276-30-git-send-email-prarit@redhat.com>
In-Reply-To: <1310994528-26276-1-git-send-email-prarit@redhat.com>
References: <1310994528-26276-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of the new SMBIOS and System Firmware code:

- cleanup of includes for dmi.h and mod_devicetable.h which were included in
some files that did not need them

Cc: johnpol@2ka.mipt.ru
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 drivers/w1/masters/ds2490.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index 02bf7bf..56c2f90 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -21,7 +21,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/mod_devicetable.h>
 #include <linux/usb.h>
 #include <linux/slab.h>
 
-- 
1.6.5.2

