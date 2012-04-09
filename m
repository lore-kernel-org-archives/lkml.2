Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab2DHLgl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 07:36:41 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53963 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab2DHLgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 07:36:40 -0400
Date: Mon, 9 Apr 2012 13:36:13 +0200
From: Adhir Ramjiawan <adhirramjiawan0@gmail.com>
To: abbotti@mev.co.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: comedi: fix trailing white space in ni_labpc.c This
 is a patch to the ni_labpc.c file that removes the trailing white space
 found by the checkpatch.pl tool. Signed-off-by: Adhir Ramjiawan
 <adhirramjiawan0@gmail.com>
Message-ID: <20120409113613.GA9157@f16.adhir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/comedi/drivers/ni_labpc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index 721b2be..1e5f1f4 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -37,7 +37,7 @@ boards has not
 yet been added to the driver, mainly due to the fact that
 I don't know the device id numbers.  If you have one
 of these boards,
-please file a bug report at http://comedi.org/ 
+please file a bug report at http://comedi.org/
 so I can get the necessary information from you.
 
 The 1200 series boards have onboard calibration dacs for correcting
-- 
1.7.7.6

