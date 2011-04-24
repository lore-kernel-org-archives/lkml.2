Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab1DXFgB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 01:36:01 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50866 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab1DXFf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 01:35:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=hCGAUqgOPrk05DBoctm6DSSy0sjE3bCziLVRvXZf61y2+Mm/mcHybv5Tooe76v4o+V
         I4NvL9lJVBPxZeCJF3kF5NGp4mBTx6V9P0IkUbo97cf0CUrLdYv9JsML1xZB6JEgtyhr
         x3hUa3Uzwtpw4AOkV47xYtPAt3oD1GbTI/ugA=
From: Kenji Toyama <kenji.toyama@gmail.com>
To: gregkh@suse.de, aaro.koskinen@iki.fi, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Kenji Toyama <kenji.toyama@gmail.com>
Subject: [PATCH 8/8] Staging: xgifb: Fixed header file.
Date: Sun, 24 Apr 2011 13:35:35 +0800
Message-Id: <1303623335-2577-1-git-send-email-kenji.toyama@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As suggested by checkpatch.pl, <linux/io.h> should be used instead of
<asm/io.h>.

Signed-off-by: Daniel Kenji Toyama <kenji.toyama@gmail.com>
---
 drivers/staging/xgifb/vb_util.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/xgifb/vb_util.c b/drivers/staging/xgifb/vb_util.c
index a97e44f..ea2b795 100644
--- a/drivers/staging/xgifb/vb_util.c
+++ b/drivers/staging/xgifb/vb_util.c
@@ -3,7 +3,7 @@
 #include "vb_struct.h"
 
 #include "XGIfb.h"
-#include <asm/io.h>
+#include <linux/io.h>
 #include <linux/types.h>
 
 #include "vb_util.h"
-- 
1.7.1

