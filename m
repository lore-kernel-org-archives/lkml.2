Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706Ab0CTFxs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 01:53:48 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:55781 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab0CTFxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 01:53:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=iXAWnnldM4LgxMwHDyIU3MDixoxxjF01vcbLiFeLCZOZc0GkQg6EfK/kqFw6J5SbLk
         kjsG6awVwYk0n7mF+fcX5p53GjAXBaV4Ji3F5rtQslv5wCIRiCh+2w+wwrryQetTu88o
         jMGiFLwvzqBGZuZF/J6EX3SNU1nnJ9jOD/UN8=
From: Vikram Dhillon <opensolarisdev@gmail.com>
To: gregkh@suse.de
Cc: wfp5p@virginia.edu, c-bartlett@hotmail.co.uk, npalix@diku.dk,
       hjanssen@microsoft.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, Vikram Dhillon <opensolarisdev@gmail.com>
Subject: [PATCH 2/2] Staging: hv: RingBuffer.c: Fixed a spacing issue
Date: Sat, 20 Mar 2010 01:53:25 -0400
Message-Id: <1269064405-9505-1-git-send-email-opensolarisdev@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing a minor spacing issue in accordance with checkpatch.pl.

Signed-off-by: Vikram Dhillon <opensolarisdev@gmail.com>
---
 drivers/staging/hv/RingBuffer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/hv/RingBuffer.c b/drivers/staging/hv/RingBuffer.c
index 80b8a2c..08b3c55 100644
--- a/drivers/staging/hv/RingBuffer.c
+++ b/drivers/staging/hv/RingBuffer.c
@@ -32,7 +32,7 @@
 
 
 /* Amount of space to write to */
-#define BYTES_AVAIL_TO_WRITE(r, w, z) ((w) >= (r))?((z) - ((w) - (r))):((r) - (w))
+#define BYTES_AVAIL_TO_WRITE(r, w, z) ((w) >= (r)) ? ((z) - ((w) - (r))) : ((r) - (w))
 
 
 /*++
-- 
1.6.3.3

