Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206Ab0JHKOw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 06:14:52 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54762 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757132Ab0JHKOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 06:14:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=tv/p48mVYsiKVA5F8PlufG/9BkaC/aGec/IcTSlLw6Gqvd07DHtsCfG+F+FPtJfRuU
         2+Xd4Co04HuJi3mLv8YYkZcOmyzw8dDVFSXRq66tyWz/F4KY+rOMVVgM6CpZvej3o3uh
         VoGFkMDx46Tag4JI3Q7QDvFauO6k9ZzWs/Ve8=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 1/3] Staging: speakup: Makefile: Makefile clean up
Date: Fri,  8 Oct 2010 06:14:43 -0400
Message-Id: <1286532885-5411-1-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.104.gc752e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced <modules>-objs with <modules>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/speakup/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/speakup/Makefile b/drivers/staging/speakup/Makefile
index 9923463..c5e43a5 100644
--- a/drivers/staging/speakup/Makefile
+++ b/drivers/staging/speakup/Makefile
@@ -15,7 +15,7 @@ obj-$(CONFIG_SPEAKUP_SYNTH_TXPRT) += speakup_txprt.o
 obj-$(CONFIG_SPEAKUP_SYNTH_DUMMY) += speakup_dummy.o
 
 obj-$(CONFIG_SPEAKUP) += speakup.o
-speakup-objs := \
+speakup-y := \
 	buffers.o \
 	devsynth.o \
 	i18n.o \
-- 
1.7.3.1.104.gc752e

