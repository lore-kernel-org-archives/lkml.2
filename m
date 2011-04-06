Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab1DFTO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 15:14:57 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49615 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab1DFTO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 15:14:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=baI+E7WLRXHfT2DqU8xhqYc9mROLZkUzfJquzhn/YPe/XdaDADKnd5dwVieL4dYhln
         LrCHmaStADj/M6J9HwMqkYT0OZYmz5VaJG/Wc4qSodvUcii2Bu349s/X3NVU9DJStyUE
         wdsMjsL/boMkbycrUry662JSvZyPI9ij/6Gh0=
From: nijs.michael@gmail.com
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Michael Nijs <nijs.michael@gmail.com>
Subject: [PATCH 4/4] Staging: iio: accel : sca3000_ring: Fixing code styling issues
Date: Wed,  6 Apr 2011 21:14:34 +0200
Message-Id: <1302117274-9986-1-git-send-email-nijs.michael@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Nijs <nijs.michael@gmail.com>

Fixed code styling issue.

Signed-off-by: Michael Nijs <nijs.michael@gmail.com>
---
 drivers/staging/iio/accel/sca3000_ring.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/iio/accel/sca3000_ring.c b/drivers/staging/iio/accel/sca3000_ring.c
index fd1c844..c872fdd 100644
--- a/drivers/staging/iio/accel/sca3000_ring.c
+++ b/drivers/staging/iio/accel/sca3000_ring.c
@@ -91,7 +91,7 @@ static int sca3000_rip_hw_rb(struct iio_ring_buffer *r,
 
 	/* Convert byte order and shift to default resolution */
 	if (st->bpse == 11) {
-		samples = (s16 *)(*data+1);
+		samples = (s16*)(*data+1);
 		for (i = 0; i < (num_read/2); i++) {
 			samples[i] = be16_to_cpup(
 					(__be16 *)&(samples[i]));
-- 
1.7.2.5

