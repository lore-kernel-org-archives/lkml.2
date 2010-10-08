Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168Ab0JHKNk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 06:13:40 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55761 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757063Ab0JHKNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 06:13:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=siiqhmrIplW0KnvrijMlDa/fLbIvltycaqIRiYE7PsET59vAg9SVvRr04SE8Dj+UoI
         bk+IG3Gh2/kD34DXc6vQRlQ6THLA1vq62Q4gRDxp5qAvh/7dmBrRF/0vjyTR7OocRSAo
         5ESFkPfHkVRk8tf57d2qJhmZS66KtWZTgHV10=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 2/3] Staging: speakup: devsynth: file_operations should be const
Date: Fri,  8 Oct 2010 06:13:29 -0400
Message-Id: <1286532810-5370-2-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.104.gc752e
In-Reply-To: <1286532810-5370-1-git-send-email-tdent48227@gmail.com>
References: <1286532810-5370-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed file_operation struct, so that it is const.
---
 drivers/staging/speakup/devsynth.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/speakup/devsynth.c b/drivers/staging/speakup/devsynth.c
index a465653..8b74622 100644
--- a/drivers/staging/speakup/devsynth.c
+++ b/drivers/staging/speakup/devsynth.c
@@ -56,7 +56,7 @@ static int speakup_file_release(struct inode *ip, struct file *fp)
 	return 0;
 }
 
-static struct file_operations synth_fops = {
+static const struct file_operations synth_fops = {
 	.read = speakup_file_read,
 	.write = speakup_file_write,
 	.open = speakup_file_open,
-- 
1.7.3.1.104.gc752e

