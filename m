Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab2DUMEo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 08:04:44 -0400
Received: from fallback2.mail.ru ([94.100.176.87]:60837 "EHLO
	fallback2.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab2DUMEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 08:04:43 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?QXJuZCBCZXJnbWFubg==?= <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        =?UTF-8?B?UnVzc2VsbCBLaW5n?= <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: =?UTF-8?B?UmVbMl06IGNscHM3MTF4IHBhdGNoc2V0?=
Mime-Version: 1.0
X-Mailer: mPOP Web-Mail 2.19
X-Originating-IP: [188.134.41.72]
Date: Sat, 21 Apr 2012 16:04:02 +0400
References: <1334999490-27177-1-git-send-email-shc_work@mail.ru> <201204211140.21564.arnd@arndb.de>
In-Reply-To: <201204211140.21564.arnd@arndb.de>
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 
Content-Type: text/plain; charset=utf-8
Message-Id: <E1SLZ2o-0002iH-SH.shc_work-mail-ru@f105.mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3LC4phB010273

Sat, 21 Apr 2012 11:40:21 +0000 Ğ¾Ñ‚ Arnd Bergmann <arnd@arndb.de>:
> On Saturday 21 April 2012, Alexander Shiyan wrote:
> > Hello.
> > This is patchset contains some cleanups and tricks for CLPS711X ARM target.
> > Please review and apply it to kernel tree. Comments are welcome :)
...
> This looks very nice overall, it's certainly good that you can manage to add
> support for a new soc with a net removal of lines.
> 
> Note that with the current work split, it will be Olof and me who apply
> these patches in the end, not Russell, although he will probably have
> to something to say about the patches, too, since he has done almost all the
> changes to this platform in its more active times.
> 
> From my reading of the git history, very little has happened in clps711x
> since about 2005, and we've never had a subarch maintainer for it. Are you
> interested in becoming the maintainer for it, or is this more a one-time
> effort on your side? I don't expect this to be much work for you, but it
> would be nice to have some person that can review the occasional patch
> touching multiple platforms.
> 
> Do you have any plans to add more stuff to the platform, like additional
> SoCs or more board files? Do you see value in having it included in
> a single kernel image that runs on various different ARMv4/ARMv5 based
> Socs? I assume that the answer to all of these is 'no', but you plan
> to do them, we should talk about how to make that happen.

The new processors in this series as far as I know there is not and no more will be.
Existing processors are still produced and used. We use this processor is 4-5 years
old and still expect to use in the future.

I can look at the new code is correct, but check it can only work on our custom board.

Of the new things I would like to add the ability to use gpiolib with this type of processor.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
