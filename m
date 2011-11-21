Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab1KUKhY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 05:37:24 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64088 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139Ab1KUKhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 05:37:22 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 1/8] Staging: comedi: fix initialise statics to 0 or NULL issue in ni_daq_dio24.c
Date: Mon, 21 Nov 2011 16:06:59 +0530
Message-Id: <1321871826-13581-1-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the ni_daq_dio24.c file that fixes up a initialise
statics to 0 or NULL warning found by the checkpatch.pl tool.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/ni_daq_dio24.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_dio24.c b/drivers/staging/comedi/drivers/ni_daq_dio24.c
index 49b824c..381ea6c 100644
--- a/drivers/staging/comedi/drivers/ni_daq_dio24.c
+++ b/drivers/staging/comedi/drivers/ni_daq_dio24.c
@@ -52,7 +52,7 @@ the PCMCIA interface.
 #include <pcmcia/cisreg.h>
 #include <pcmcia/ds.h>
 
-static struct pcmcia_device *pcmcia_cur_dev = NULL;
+static struct pcmcia_device *pcmcia_cur_dev;
 
 #define DIO24_SIZE 4		/*  size of io region used by board */
 
-- 
1.7.0.4

