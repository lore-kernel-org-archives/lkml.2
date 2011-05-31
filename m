Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585Ab1EaPx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 11:53:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932408Ab1EaPxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 11:53:55 -0400
Date: Tue, 31 May 2011 11:53:54 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, johnpol@2ka.mipt.ru
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20110531155354.3626.68798.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/x-c; charset=us-ascii
Subject: [RFC PATCH 30/35] drivers/w1 changes for SMBIOS and System Firmware
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/w1 changes for SMBIOS and System Firmware

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
1.7.5.1

