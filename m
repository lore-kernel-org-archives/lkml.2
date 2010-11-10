Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab0KJKvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 05:51:41 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47937 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab0KJKvi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 05:51:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=kqV7178St56mpLxz+0tPwxOzPWEDCsBWlNJMaSpSZLWl3/Pqf1/pWNeQGSKwhikmEY
         J5lOT/ROjEyteLwc/Too3bc+82Od0cCPjLwPKAkY9ss5UtedT39Zg0bwkIE34XpHTjAN
         kpJc/Hk7dq9FNXt2J0RTXOG8GPwqjvT61bW4E=
MIME-Version: 1.0
Date: Wed, 10 Nov 2010 18:51:37 +0800
Message-ID: <AANLkTi=b+KWcYqXCteuiw0OnKqfSvWQCA+B-HUEy90R8@mail.gmail.com>
Subject: [PATCH] kdb: use macro instead of const number
From: jovi zhang <bookjovi@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>, Martin Hicks <mort@sgi.com>,
        Dmitry Torokhov <dtor@mail.ru>, Rusty Russell <rusty@rustcorp.com.au>,
        kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's better to use macro KDB_BASE_CMD_MAX instead of 50

Signed-off-by: jovi zhang <bookjovi@gmail.com>
kernel/debug/kdb/kdb_main.c |    2 +-
1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 37755d6..3579105 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -78,7 +78,7 @@ static unsigned int kdb_continue_catastrophic;
static kdbtab_t *kdb_commands;
#define KDB_BASE_CMD_MAX 50
static int kdb_max_commands = KDB_BASE_CMD_MAX;
-static kdbtab_t kdb_base_commands[50];
+static kdbtab_t kdb_base_commands[KDB_BASE_CMD_MAX];
#define for_each_kdbcmd(cmd, num)                                      \
       for ((cmd) = kdb_base_commands, (num) = 0;                      \
            num < kdb_max_commands;                                    \
