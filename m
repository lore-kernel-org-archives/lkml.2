Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab1GUOZK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 10:25:10 -0400
Received: from mailhost-r5-m2.mangoosta.org ([78.40.49.195]:22099 "EHLO
	smtp-delay2.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751231Ab1GUOZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 10:25:08 -0400
X-Greylist: delayed 557 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Jul 2011 10:25:08 EDT
From: Jean Marc Olivieri <jmolivieri@algoria.fr>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: 2.6.33.16 Documentation/lguest breaks compile under debian x86
Thread-Topic: 2.6.33.16 Documentation/lguest breaks compile under debian x86
Thread-Index: AQHMR7CtTPHrGv7/Yk6BvP12vh3gtA==
Date: Thu, 21 Jul 2011 14:15:44 +0000
Message-ID: <1CCDCE528ADEE240A3F216D1B406A8F3472E91EF@PDCParis.algoria.local>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.111.105]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p6LEPJsT016451

I'm currently using :
Distributor ID:	Debian
Description:	Debian GNU/Linux 6.0.2 (squeeze)
Release:	6.0.2
Codename:	squeeze
On x86 PC.

Kernel 2.6.33.16 fails to compile due to unfound include. Thus I got rid of it and it works.
I successfully built kernels against :
	- x86
	- x64

Here's the patch :

diff -u -r a/linux-2.6.33.16/Documentation/lguest/lguest.c b/linux-2.6.33.16/Documentation/lguest/lguest.c
--- a/linux-2.6.33.16/Documentation/lguest/lguest.c	2011-07-13 05:31:47.000000000 +0200
+++ b/linux-2.6.33.16/Documentation/lguest/lguest.c	2011-07-21 15:16:03.331040033 +0200
@@ -34,7 +34,6 @@
 #include <sys/uio.h>
 #include <termios.h>
 #include <getopt.h>
-#include <zlib.h>
 #include <assert.h>
 #include <sched.h>
 #include <limits.h>


Jean-Marc OLIVIERI
IngÃ©nieur dÃ©veloppement
+33 1 41 90 66 55
jmolivieri@algoria.fr



ALGORIA - Ã‰diteur de TWS
31, rue Ernest Renan 92130 Issy-les-Moulineaux 
+33 1 41 90 66 66 (std) / +33 1 41 90 66 56 (fax)
www.algoria.fr

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
