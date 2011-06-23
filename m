Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115Ab1FWR06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:26:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933079Ab1FWRZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:25:18 -0400
Date: Thu, 23 Jun 2011 13:25:16 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, johnpol@2ka.mipt.ru
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20110623172516.27768.98345.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/plain; charset=us-ascii
Subject: [PATCH 30/35] drivers/w1 changes for SMBIOS and System Firmware
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/w1 changes for SMBIOS and System Firmware

As part of the new SMBIOS and System Firmware code:

- cleanup of includes for dmi.h and mod_devicetable.h which were included in
some files that did not need them

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
1.7.5.4

