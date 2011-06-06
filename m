Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611Ab1FFS6z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 14:58:55 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46411 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757376Ab1FFS6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:58:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=WfcukoHriB5fP5qtIL/whHJWXuNoe5Coaz4nOvk0plNZY8Vyro81Wht/GGMlqM8bWi
         49z0I6fgDpY785Oef899H79eqxedwdnu88Y9DPxXGCycOqn3ueXjNnYwFo0fTF8GAzNB
         XyCINiBCmUKxUzD+qYPkECmOpUqpGGcOJFzXc=
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 4/9] kconfig: add missing <ctype.h> inclusion
Date: Mon,  6 Jun 2011 14:58:26 -0400
Message-Id: <1307386711-8866-5-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.3.4.574.g608b.dirty
In-Reply-To: <1307386711-8866-1-git-send-email-lacombar@gmail.com>
References: <1307386711-8866-1-git-send-email-lacombar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This header is needed when using isspace(3) function family.

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 scripts/kconfig/menu.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index d64108b..24547fe 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -3,6 +3,7 @@
  * Released under the terms of the GNU GPL v2.0.
  */
 
+#include <ctype.h>
 #include <stdarg.h>
 #include <stdlib.h>
 #include <string.h>
-- 
1.7.3.4.574.g608b.dirty

