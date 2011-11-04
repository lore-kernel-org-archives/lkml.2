Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159Ab1KDSXH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 14:23:07 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:54623 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933135Ab1KDSXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 14:23:04 -0400
Message-ID: <4EB42D5B.6050201@xenotime.net>
Date: Fri, 04 Nov 2011 11:22:19 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Antonio Ospite <ospite@studenti.unina.it>
Subject: [PATCH 4/8] Documentation: update CodingStyle use of braces
References: <4EB423D8.9030102@xenotime.net>
In-Reply-To: <4EB423D8.9030102@xenotime.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Antonio Ospite <ospite@studenti.unina.it>

After commit 38829dc highlight that if _only_one_ branch of a
conditional statement is a single statement, then braces are to be used
on both branches.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 Documentation/CodingStyle |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- lnx1104.orig/Documentation/CodingStyle
+++ lnx1104/Documentation/CodingStyle
@@ -166,8 +166,8 @@ if (condition)
 else
 	do_that();
 
-This does not apply if one branch of a conditional statement is a single
-statement. Use braces in both branches.
+This does not apply if only one branch of a conditional statement is a single
+statement; in the latter case use braces in both branches:
 
 if (condition) {
 	do_this();
