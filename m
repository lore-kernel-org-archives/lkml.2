Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713Ab0JSCrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 22:47:08 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:42546 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756846Ab0JSCrH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 22:47:07 -0400
Date: Tue, 19 Oct 2010 11:47:24 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH 2/9 v2] ARM: S3C64XX: add nand support for mach-real6410
In-reply-to: <AANLkTinwBj2QtLdFMGDmqipJD9g1O9QzRUUZpCn=0q-z@mail.gmail.com>
To: "'Darius Augulis'" <augulis.darius@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, paulius.zaleckas@gmail.com,
        linux-kernel@vger.kernel.org, ben-linux@fluff.org
Message-id: <04ef01cb6f37$f7733c80$e659b580$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=ISO-8859-1
Content-language: ko
Content-transfer-encoding: 8BIT
Thread-index: ActuzLNB8yqLC4l3QJWnsycjkhjJ9QAaob8g
References: <20100929192354.25307.40197.stgit@darius-desktop>
 <20100929193134.25307.65614.stgit@darius-desktop>
 <04a401cb6ec7$b8291b00$287b5100$%kim@samsung.com>
 <AANLkTinwBj2QtLdFMGDmqipJD9g1O9QzRUUZpCn=0q-z@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Darius Augulis wrote:
> 
> On Mon, Oct 18, 2010 at 4:23 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> > Darius Augulis wrote:
> >>
> >> Add nand device support and mtd partition table
> >> for mach-real6410
> >>
> >> Signed-off-by: Darius Augulis <augulis.darius@gmail.com>
> >> ---
> >>
> >> Changelog since v1:
> >>  - Changed dependency on other patches
> >>
> >>  arch/arm/mach-s3c64xx/Kconfig         |    1 +
> >>  arch/arm/mach-s3c64xx/mach-real6410.c |   40
> >> +++++++++++++++++++++++++++++++++
> >>  2 files changed, 41 insertions(+), 0 deletions(-)
> >>

(snip)

> >> @@ -249,6 +288,7 @@ static void __init real6410_machine_init(void)
> >>               real6410_lcd_pdata.win[0]->win_mode.yres);
> >>
> >>       s3c_fb_set_platdata(&real6410_lcd_pdata);
> >> +     s3c_nand_set_platdata(&real6410_nand_info);
> >>
> >>       /* configure nCS1 width to 16 bits */
> >>
> > Where is 'END' of patch mark?
> > maybe broken your patch file...?
> 
> Confused. What 'END' mark are you missing?
> All patches are sent by stg mail, all apply fine, no conflict or other
> messages from stgit.
> Please explain what you mean.

Generally, there is '--' mark and git version in the bottom of patch...
If you make patch file using git-format-patch, maybe automatically add it.

> 
> p.s. checkpatch.pl also doesn't report any error.
> 
Yes...ok.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

