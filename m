Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121Ab2H3W7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 18:59:17 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38426 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab2H3W7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 18:59:15 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: RE: [PATCH 0/8] lp8727_charger: cleanup code
Thread-Topic: [PATCH 0/8] lp8727_charger: cleanup code
Thread-Index: Ac2Go69seS4U+KqpTO+wdMwOBAY4NP//hMWA//7HbwA=
Date: Thu, 30 Aug 2012 22:59:06 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF1D3B@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F41EF1C6B@DQHE02.ent.ti.com>
 <20120830121521.GC11289@lizard>
In-Reply-To: <20120830121521.GC11289@lizard>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.123]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7UMxMss027141

> -----Original Message-----
> From: Anton Vorontsov [mailto:anton.vorontsov@linaro.org]
> Sent: Thursday, August 30, 2012 9:15 PM
> To: Kim, Milo
> Cc: linux-kernel@vger.kernel.org; David Woodhouse
> Subject: Re: [PATCH 0/8] lp8727_charger: cleanup code
> 
> On Thu, Aug 30, 2012 at 11:37:16AM +0000, Kim, Milo wrote:
> > LP8727 driver should be patched for several reasons.
> >
> > (a) Need to clean up _probe()/_remove()
> > (b) Not secure code when the platform data is NULL
> > (c) Interrupt handling
> >     Two threads are running for handling one IRQ.
> >     One is for the IRQ pin, the other is used for delayed processing.
> >     This is unusual and can be enhanced.
> > (d) Misuse of mutex code
> > (e) Lots of definitions should be fixed
> > (f) Others..
> 
> Thanks a lot for the cleanups, this is much appreciated! The cleanups
> themselves look great, but I'd really like to see them more separated.
> 
> Thanks,
> Anton.

Sorry to bother you.
I'll resend the patch-set separately.
Thanks a lot for detailed review.

Best Regards,
Milo
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
