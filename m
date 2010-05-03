Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab0ECJiw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 05:38:52 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:42860 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939Ab0ECJiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 05:38:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=bDfTJC5ZF1QNLYfkLmtIzdMmvHErLBminN0ghFbGJ65sRpTzWtd/2k93K7/J5zDZqY
         m9jR6tMLOvEgs4bPzyDln2Jj8W7QV4uBFT9JIkgAJY03nx4eeIELTx/TyOdY0o7Z97k/
         sUtnyuzamL3/q9P1on8wy3VGW3kqZPwEdVL2M=
From: Mark <reodge@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, john.d.sheehan@gmail.com,
       mithlesh@linsyssoft.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mark <reodge@gmail.com>
Subject: [PATCH] Staging: comedi: Moved some EXPORT_SYMBOL() macros
Date: Mon,  3 May 2010 17:39:09 +0800
Message-Id: <1272879549-26711-1-git-send-email-reodge@gmail.com>
X-Mailer: git-send-email 1.7.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to range.c that rearranges some EXPORT_SYMBOL() macros to please
checkpatch.pl

Signed-off-by: Mark Rankilor <reodge@gmail.com>
---
 drivers/staging/comedi/range.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/range.c b/drivers/staging/comedi/range.c
index 6b03a69..8a1cefd 100644
--- a/drivers/staging/comedi/range.c
+++ b/drivers/staging/comedi/range.c
@@ -25,16 +25,16 @@
 #include <linux/uaccess.h>
 
 const struct comedi_lrange range_bipolar10 = { 1, {BIP_RANGE(10)} };
-const struct comedi_lrange range_bipolar5 = { 1, {BIP_RANGE(5)} };
-const struct comedi_lrange range_bipolar2_5 = { 1, {BIP_RANGE(2.5)} };
-const struct comedi_lrange range_unipolar10 = { 1, {UNI_RANGE(10)} };
-const struct comedi_lrange range_unipolar5 = { 1, {UNI_RANGE(5)} };
-const struct comedi_lrange range_unknown = { 1, {{0, 1000000, UNIT_none} } };
 EXPORT_SYMBOL(range_bipolar10);
+const struct comedi_lrange range_bipolar5 = { 1, {BIP_RANGE(5)} };
 EXPORT_SYMBOL(range_bipolar5);
+const struct comedi_lrange range_bipolar2_5 = { 1, {BIP_RANGE(2.5)} };
 EXPORT_SYMBOL(range_bipolar2_5);
+const struct comedi_lrange range_unipolar10 = { 1, {UNI_RANGE(10)} };
 EXPORT_SYMBOL(range_unipolar10);
+const struct comedi_lrange range_unipolar5 = { 1, {UNI_RANGE(5)} };
 EXPORT_SYMBOL(range_unipolar5);
+const struct comedi_lrange range_unknown = { 1, {{0, 1000000, UNIT_none} } };
 EXPORT_SYMBOL(range_unknown);
 
 /*
-- 
1.7.0.5

