Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541Ab2CWQhL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 12:37:11 -0400
Received: from fallback1.mail.ru ([94.100.176.18]:36360 "EHLO
	fallback1.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756618Ab2CWQhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 12:37:09 -0400
X-Greylist: delayed 33233 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Mar 2012 12:37:08 EDT
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?R2VlcnQgVXl0dGVyaG9ldmVu?= <geert@linux-m68k.org>
Cc: =?UTF-8?B?VGhvbWFzIEdsZWl4bmVy?= <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: =?UTF-8?B?UmVbMl06IFtQQVRDSF0gRml4IGJ1aWxkIGVycm9yIHdpdGggIVNNUCAmJiAh?=
 =?UTF-8?B?R0VORVJJQ19IQVJESVJRUw==?=
Mime-Version: 1.0
X-Mailer: mPOP Web-Mail 2.19
X-Originating-IP: 192.168.1.19 via proxy [217.119.30.118]
Date: Fri, 23 Mar 2012 12:13:00 +0400
References: <1332487384-13803-1-git-send-email-shc_work@mail.ru> <CAMuHMdXoJhWVoRrhgYzVcv3tbThzmtiZ4ZY6pjUM2eji5XuK2A@mail.gmail.com>
In-Reply-To: <CAMuHMdXoJhWVoRrhgYzVcv3tbThzmtiZ4ZY6pjUM2eji5XuK2A@mail.gmail.com>
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 
Content-Type: text/plain; charset=utf-8
Message-Id: <E1SAzcK-0001aj-CS.shc_work-mail-ru@f287.mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2NGc3uw030973

Fri, 23 Mar 2012 08:46:15 +0100 Ğ¾Ñ‚ Geert Uytterhoeven <geert@linux-m68k.org>:
> On Fri, Mar 23, 2012 at 08:23, Alexander Shiyan <shc_work@mail.ru> wrote:
> > When compile kernel with !SMP && !GENERIC_HARDIRQS we are have
> > following error:
> Is this on uniprocessor s390?
No. I trying to fix other problem with ARM Cirrus Logic EP7312 that do not work since 2.6.30-rc1.
The problem appear after commit:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=c61b79b6ef266890954213a701d8f6021d8c1289

I just playing with this commit and found this compile error.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
