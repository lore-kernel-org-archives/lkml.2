Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716Ab0FQIln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 04:41:43 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56848 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059Ab0FQIll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 04:41:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=cWxqtO/PVKvl99oAF6kgQ2RMzVyEzWVrxxEvPW28nNON8p1c6u1eCLJoKDCO97cTap
         tcAFTyeS/mPpKKwnQTr9Mq+pvAtAMAZUW8OSw/RUC2whap5eU74q7s0tKdR4twb+Qrin
         onZZoYSfnKHi5C49D4yE1/AS1yARFLtWneu9c=
From: Matti Lammi <mattij.lammi@gmail.com>
To: gregkh@suse.de, mattij.lammi@gmail.com, mithlesh@linsyssoft.com,
       tfransosi@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Matti Lammi <matti.lammi@gmail.com>
Subject: [PATCH] Drivers: Staging: Removed one unnecessary space
Date: Thu, 17 Jun 2010 11:41:33 +0300
Message-Id: <1276764093-14539-1-git-send-email-mattij.lammi@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing special really, just a small fix.

Signed-off-by: Matti Lammi <matti.lammi@gmail.com>
---
 drivers/staging/otus/apdbg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/otus/apdbg.c b/drivers/staging/otus/apdbg.c
index b59028e..32c26e5 100644
--- a/drivers/staging/otus/apdbg.c
+++ b/drivers/staging/otus/apdbg.c
@@ -180,6 +180,6 @@ int main(int argc, char **argv)
 	if (argc < 3) {
 		fprintf(stderr, "%s: usage is \"%s <ifname> <operation>"
 				"[<address>] [<value>]\"\n", prgname, prgname);
-		fprintf(stderr, "valid operation : read, write, mem, reg, \n");
+		fprintf(stderr, "valid operation : read, write, mem, reg,\n");
 		fprintf(stderr, "		: txd, rxd, rmem, wmem\n");
 		fprintf(stderr, "		: dmat, regt, test\n");

--
1.6.0.4

