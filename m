Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853Ab0CaXXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 19:23:12 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:38075 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804Ab0CaXXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 19:23:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=eUUNch7Bn7U8zF7j/SzLWI14LGMKYMXS0ad+wm8XUP8feL5zWJBBpCGYsM4at1nsx3
         jBLyuN09Mj/JKWT60bMQKKwWM4RKpp6SzDKgFQY4N5MDFK7AWmsZYDEokKf5iFL+IA/4
         wzfRaEOmXnCGB1+LW/k3w9micOrR+WrTyjeNI=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH] Remove empty comment.
Date: Wed, 31 Mar 2010 16:22:54 -0700
Message-Id: <1270077774-4399-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove an empty comment.


Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
---
 drivers/acpi/power.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index 0f30c3c..8ed24c2 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -171,7 +171,6 @@ static int acpi_power_get_list_state(struct acpi_handle_list *list, int *state)
 		return -EINVAL;
 
 	/* The state of the list is 'on' IFF all resources are 'on'. */
-	/* */
 
 	for (i = 0; i < list->count; i++) {
 		/*
-- 
1.6.5.GIT

