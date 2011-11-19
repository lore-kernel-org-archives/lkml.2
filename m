Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197Ab1KSEij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 23:38:39 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59220 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080Ab1KSEig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 23:38:36 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 21/25] Staging: comedi: fix initialise statics to 0 or NULL issue in pcl816.c
Date: Sat, 19 Nov 2011 10:06:53 +0530
Message-Id: <1321677417-2415-21-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1321677417-2415-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1321677417-2415-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the pcl816.c file that fixes up a initialise statics to 0 or NULL
warning found by the checkpatch.pl tool.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/pcl816.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl816.c b/drivers/staging/comedi/drivers/pcl816.c
index 0b9bee3..96cd7ec 100644
--- a/drivers/staging/comedi/drivers/pcl816.c
+++ b/drivers/staging/comedi/drivers/pcl816.c
@@ -155,8 +155,8 @@ static int pcl816_attach(struct comedi_device *dev,
 static int pcl816_detach(struct comedi_device *dev);
 
 #ifdef unused
-static int RTC_lock = 0;	/* RTC lock */
-static int RTC_timer_lock = 0;	/* RTC int lock */
+static int RTC_lock;	/* RTC lock */
+static int RTC_timer_lock;	/* RTC int lock */
 #endif
 
 static struct comedi_driver driver_pcl816 = {
-- 
1.7.0.4

