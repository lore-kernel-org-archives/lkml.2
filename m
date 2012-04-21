Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872Ab2DULa3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 07:30:29 -0400
Received: from f78.mail.ru ([217.69.128.226]:40321 "EHLO f78.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291Ab2DULa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 07:30:28 -0400
X-Greylist: delayed 2369 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Apr 2012 07:30:27 EDT
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?QXJuZCBCZXJnbWFubg==?= <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        =?UTF-8?B?UnVzc2VsbCBLaW5n?= <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: =?UTF-8?B?UmVbMl06IFtQQVRDSCAwMi8xN10gQVJNIGNscHM3MTF4OiBBZGRlZCBDaXJy?=
 =?UTF-8?B?dXMgTG9naWMgRVA3MzEyIENQVSB2YXJpYW50?=
Mime-Version: 1.0
X-Mailer: mPOP Web-Mail 2.19
X-Originating-IP: [188.134.41.72]
Date: Sat, 21 Apr 2012 15:30:24 +0400
References: <1334999490-27177-1-git-send-email-shc_work@mail.ru> <1334999490-27177-3-git-send-email-shc_work@mail.ru> <201204211121.49610.arnd@arndb.de>
In-Reply-To: <201204211121.49610.arnd@arndb.de>
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 
Content-Type: text/plain; charset=utf-8
Message-Id: <E1SLYWG-0001EX-Qj.shc_work-mail-ru@f78.mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3LBUabk010108

Sat, 21 Apr 2012 11:21:49 +0000 Ğ¾Ñ‚ Arnd Bergmann <arnd@arndb.de>:
> On Saturday 21 April 2012, Alexander Shiyan wrote:
> > 
> > Added register definitions specific to EP7312 and the necessary
> > configuration options.
> > 
> > Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> > ---
> >  arch/arm/include/asm/hardware/ep7312.h         |  106 ++++++++++++++++++++++++
> >  arch/arm/mach-clps711x/Kconfig                 |    9 ++-
> >  arch/arm/mach-clps711x/include/mach/hardware.h |    4 +
> >  drivers/net/irda/Kconfig                       |    3 +-
> >  4 files changed, 119 insertions(+), 3 deletions(-)
> >  create mode 100644 arch/arm/include/asm/hardware/ep7312.h
> 
> I'm missing some historical background here. Why are these files in asm/hardware
> rather than in mach/? Should we move them to the platform directory?

I just placed this header into current place for this cpu.
Of course it can be moved (with others) into platform directory.
I can do other patch for this operation later. For this patch I think it is not important.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
