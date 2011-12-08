Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab1LHMww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 07:52:52 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58130 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab1LHMwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 07:52:51 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 01/30] Staging: comedi: fix initialise statics to 0 or NULL issue in cb_das16_cs.c
Date: Thu,  8 Dec 2011 18:21:56 +0530
Message-Id: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_das16_cs.c file that fixes up a initialise
statics to 0 or NULL warning found by the checkpatch.pl tool.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index 9beb34c..49404f4 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -99,7 +99,7 @@ static struct comedi_driver driver_das16cs = {
 	.detach = das16cs_detach,
 };
 
-static struct pcmcia_device *cur_dev = NULL;
+static struct pcmcia_device *cur_dev;
 
 static const struct comedi_lrange das16cs_ai_range = { 4, {
 							   RANGE(-10, 10),
-- 
1.7.0.4

