Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab0HPM4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 08:56:10 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:64670 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab0HPM4J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 08:56:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=A/viLfv+9TVyozrLW2qaQJvL/wnf+vnbukzRF6MH2IXOfv6hmXMUBTtU513WCGzBIN
         h0YwvMzHc3BiPMBwu556T6toob5l0atPwuNc3dFDsvVxwqMMVM3hx1FGwHDzQ+rhZk7O
         kPdKISZifaIAD23SK7mG1WdiTdaFos/m9Ycxc=
MIME-Version: 1.0
In-Reply-To: <25B60CDC2F704E4E9D88FFD52780CB4C0597FEB568@SC-VEXCH1.marvell.com>
References: <AANLkTi=YSS0-Nf4MWOw30YDrCdrkmtzLhv7DXfsoJTjX@mail.gmail.com>
 <53612FE6B944314AAADB181E45A45B64133DDFC156@sc-vexch3.marvell.com>
 <AANLkTimh=dbUV75ZVXuhknt4FiMtximXLY8xoADfbe=q@mail.gmail.com> <25B60CDC2F704E4E9D88FFD52780CB4C0597FEB568@SC-VEXCH1.marvell.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Mon, 16 Aug 2010 20:55:48 +0800
Message-ID: <AANLkTimjKThiuNPhVyOh-SL1e7Zwu2R8Sd2DXAFixpY+@mail.gmail.com>
Subject: Re: [PATCH] [MTD] [NAND] pxa3xx: fix timing and cmdset for samsung2GbX8
To: Haojian Zhuang <hzhuang1@marvell.com>
Cc: Lei Wen <leiwen@marvell.com>, Axel Lin <axel.lin@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 8:49 PM, Haojian Zhuang <hzhuang1@marvell.com> wrote:
> http://lists.infradead.org/pipermail/linux-mtd/2010-July/subject.html
>
> They're re-posted in July. Please search the subjects in that page. They're totally 29 patches.
>
> By the way, David, what's the result of review on these patches? We already posted for several times.
>

I've actually reviewed some of the patches and gave my Ack. For those
patches, I think they can be merged early.

And overall, they look good. Yet 29 patch in a whole is still a bit too
much, would be good to see them logically be separated into several
patch series.

> Thanks
> Haojian
>
> -----Original Message-----
> From: Eric Miao [mailto:eric.y.miao@gmail.com]
> Sent: 2010年8月16日 8:44 PM
> To: Lei Wen
> Cc: Axel Lin; linux-kernel; David Woodhouse; linux-mtd@lists.infradead.org; Haojian Zhuang
> Subject: Re: [PATCH] [MTD] [NAND] pxa3xx: fix timing and cmdset for samsung2GbX8
>
> On Mon, Aug 16, 2010 at 8:34 PM, Lei Wen <leiwen@marvell.com> wrote:
>> Hi Axel,
>>
>> I suggest not merge your patch into mainline code. Since I have a large series of patch which reconstruct the nand flash definition, this fix would no longer be needed.
>>
>
> Lei, would you please point the URL of the patch series (possibly by
> searching linux-mtd archive or some other mailing list archive) so that
> Axel can have a reference and be involved?
>
> - eric
>
