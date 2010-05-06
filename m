Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247Ab0EFJuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 05:50:18 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:42132 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756566Ab0EFJuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 05:50:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=YFUNscWXq+s7gFHDaoXD1RDwvKDPt3PfuGtiei4SxwYpe8M8r8sXhaIHhsKmbms/39
         K3i9WxatOrBTvatWqk/rY5CzGLmZIU3HFKRqLfDdp8AfOLPevshIb7Amy4PyDBy6VBpX
         rfXOJCzRpX7jMdMQIKVrSgfVwwxawU4kBgb3c=
From: Mark <reodge@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mark <reodge@gmail.com>
Subject: [PATCH] Staging: comedi: Fixed long line length in comedidev.h
Date: Thu,  6 May 2010 17:49:37 +0800
Message-Id: <1273139377-9274-1-git-send-email-reodge@gmail.com>
X-Mailer: git-send-email 1.7.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a long line length in comedidev.h to make checkpatch.pl happy

Signed-off-by: Mark Rankilor <reodge@gmail.com>
---
 drivers/staging/comedi/comedidev.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index c38ebb4..4eb2b77 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -374,7 +374,9 @@ enum subdevice_runflags {
 	SRF_RUNNING = 0x08000000
 };
 
-int comedi_check_chanlist(struct comedi_subdevice *s, int n, unsigned int *chanlist);
+int comedi_check_chanlist(struct comedi_subdevice *s,
+			  int n,
+			  unsigned int *chanlist);
 unsigned comedi_get_subdevice_runflags(struct comedi_subdevice *s);
 
 /* range stuff */
-- 
1.7.0.5

