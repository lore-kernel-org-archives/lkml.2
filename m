Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab1FWGaE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 02:30:04 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44207 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030Ab1FWGaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 02:30:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=K8vkIe7JgkiMYz6DIuOLZr2IniSzf0MGXgBaBmiUUFb7iBMQi0pN2m/HPc8PEziaPh
         svMfQ3IkNJOvAqJvKPswpla3tvF/Hq6qGKFhgxZbesZ68f5qy556gnVKC11Jo3M/Zosf
         DPq6qAf1Fj4+dB7E01yrr3ZzKfsSQ91nD162Y=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 2/3]drivers:input:serio:libps2.c Fix typo arrrives.
Date: Wed, 22 Jun 2011 23:29:19 -0700
Message-Id: <1308810560-23742-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1308810560-23742-1-git-send-email-justinmattock@gmail.com>
References: <1308810560-23742-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

Fix a typo in a comment.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/input/serio/libps2.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/serio/libps2.c b/drivers/input/serio/libps2.c
index 980af94..07a8363 100644
--- a/drivers/input/serio/libps2.c
+++ b/drivers/input/serio/libps2.c
@@ -210,7 +210,7 @@ int __ps2_command(struct ps2dev *ps2dev, unsigned char *param, int command)
 	/*
 	 * Some devices (Synaptics) peform the reset before
 	 * ACKing the reset command, and so it can take a long
-	 * time before the ACK arrrives.
+	 * time before the ACK arrives.
 	 */
 	if (ps2_sendbyte(ps2dev, command & 0xff,
 			 command == PS2_CMD_RESET_BAT ? 1000 : 200))
-- 
1.7.5.4

