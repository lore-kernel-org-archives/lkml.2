Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab1GKMar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 08:30:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45739 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756454Ab1GKMaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 08:30:46 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 13/13] Staging: comedi: fix indentation issue in pcl818.c
Date: Mon, 11 Jul 2011 18:13:22 +0530
Message-Id: <1310388202-23400-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH]Staging: comedi: fix spaces with tab in pcl818.c>
References: <[PATCH]Staging: comedi: fix spaces with tab in pcl818.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the pcl818.c file that fixes up a ERROR: code indent should use tabs where possible  found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---

Spaces is replaced by tab

 drivers/staging/comedi/drivers/pcl818.c |   36 +++++++++++++++---------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index 3ac489d..37dcd7c 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -242,8 +242,8 @@ static const struct comedi_lrange range_pcl818l_h_ai = { 4, {
 };
 
 static const struct comedi_lrange range718_bipolar1 = { 1, {BIP_RANGE(1),} };
-static const struct comedi_lrange range718_bipolar0_5 =
-    { 1, {BIP_RANGE(0.5),} };
+static const struct comedi_lrange range718_bipolar0_5 =
+	{ 1, {BIP_RANGE(0.5),} };
 static const struct comedi_lrange range718_unipolar2 = { 1, {UNI_RANGE(2),} };
 static const struct comedi_lrange range718_unipolar1 = { 1, {BIP_RANGE(1),} };
 
-- 
1.6.5.2

