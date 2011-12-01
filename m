Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab1LAKMk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 05:12:40 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:41231 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257Ab1LAKMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 05:12:38 -0500
X-AuditID: cbfee61b-b7bdbae000001970-10-4ed75315957a
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Wim Van Sebroeck'" <wim@iguana.be>
Cc: "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Dmitry Artamonow'" <mad_soft@inbox.ru>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "'Ben Dooks'" <ben-linux@fluff.org>, linux-watchdog@vger.kernel.org
References: <1321433173-17757-1-git-send-email-mad_soft@inbox.ru>
 <CAJuYYwTv3d9Wg8TDBEkc0r3BweUiLdqVwGdMU4iKpK0B+EM=GA@mail.gmail.com>
 <045d01ccaffb$00710240$015306c0$%kim@samsung.com>
 <20111201090934.GO23376@infomag.iguana.be>
In-reply-to: <20111201090934.GO23376@infomag.iguana.be>
Subject: RE: [PATCH] watchdog: fix initialisation printout in s3c2410_wdt
Date: Thu, 01 Dec 2011 19:12:36 +0900
Message-id: <047001ccb011$bff04930$3fd0db90$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcywCXAro9mrOqR4T+SryES5NzldmwACDToQ
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wim Van Sebroeck wrote:
> 
> Hi Kim,
> 
> > Thomas Abraham wrote:
> > >
> > > On 16 November 2011 14:16, Dmitry Artamonow <mad_soft@inbox.ru> wrote:
> > > > Looks like a typo creeped in, and driver prints
> > > > s3c2410-wdt s3c2410-wdt: watchdog active, reset abled, irq abled
> > > >
> > > > instead of
> > > > s3c2410-wdt s3c2410-wdt: watchdog active, reset enabled, irq enabled
> > > >
> > > > Also it may completely disinform about irq status, as it prints
> > > > "irq enabled" when S3C2410_WTCON_INTEN is in fact 0.
> > > >
> > > > Fix it.
> > > >
> > > > Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
> > > > ---
> > > >
> > > > It seems to be here for a long time, but I don't think it's
> > > > important enough for cc-ing stable.
> > > >
> > > > Also I haven't tested it, as I don't have a hardware, but it's
> > > > rather trivial (and yes, I checked with datasheet that 1 in
> > > > S3C2410_WTCON_*EN bits really means 'enabled')
> > > >
> > >
> > > Tested on Exynos4210 based Origen board. This patch fixed in incorrect
> > > "irq enabled" message at bootup. Thanks for this fix.
> > >
> > > Tested-by: Thomas Abraham <thomas.abraham@linaro.org>
> > >
> >
> > Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> >
> > Hi Wim,
> > Please pick this up in your tree and if any problem, let me know.
> 
> See commit 20403e845f9988446c5b48024ff4d0c3a5929f7d in the linux git tree.
> 
OK :)

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

