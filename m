Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab0JPN1c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 09:27:32 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37693 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335Ab0JPN1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 09:27:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=IP2ZEPK+OTkjpTjq3JyNtO4BnrvRGjd1ysKT0Asb+OzmRJqDiXsx1MjqIAUTKdwZ+o
         DJ0nsmYkwoth7nImDXITfGmk4SL3h+GZk7J94ge0gswE0B5O29zjjvqMpmg3QJC1BurQ
         2ZKJCSzXpmbL1kHyQvQBB6yPA6Fg/Gz4cj0js=
From: Tracey Dent <tdent48227@gmail.com>
To: gregkh@suse.de, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Cc: mhw@wittsend.com, minyard@acm.org,
        openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 04/05] Drivers: char: pcmcia: ipwireless: Makefile: replace the use of <module>-objs with <module>-y
Date: Sat, 16 Oct 2010 09:26:52 -0400
Message-Id: <1287235613-1545-4-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.104.gc752e
In-Reply-To: <1287235613-1545-1-git-send-email-tdent48227@gmail.com>
References: <1287235613-1545-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/char/pcmcia/ipwireless/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/pcmcia/ipwireless/Makefile b/drivers/char/pcmcia/ipwireless/Makefile
index b71eb59..db80873 100644
--- a/drivers/char/pcmcia/ipwireless/Makefile
+++ b/drivers/char/pcmcia/ipwireless/Makefile
@@ -6,5 +6,5 @@
 
 obj-$(CONFIG_IPWIRELESS) += ipwireless.o
 
-ipwireless-objs := hardware.o main.o network.o tty.o
+ipwireless-y := hardware.o main.o network.o tty.o
 
-- 
1.7.3.1.104.gc752e

