Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab0HPNzg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 09:55:36 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53969 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab0HPNze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 09:55:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=YTR2Ez5nG0dHlYQr8b2xyNdhdEW8q9XiMa0XgNcI1RT5JCvS2UtjtZVCSccb0M0+nF
         obBHJbfNKZcZwgu5lPFJYstMpCU+HPoDTOawfSul9CQtOotX8SHiT0sFbpNeLAAeV3Ct
         w0t+X7pCJRG85AT/Isap+vyn41puDFgC5+iSI=
MIME-Version: 1.0
In-Reply-To: <1281963920.21549.81.camel@localhost>
References: <AANLkTi=YSS0-Nf4MWOw30YDrCdrkmtzLhv7DXfsoJTjX@mail.gmail.com>
 <53612FE6B944314AAADB181E45A45B64133DDFC156@sc-vexch3.marvell.com>
 <AANLkTimh=dbUV75ZVXuhknt4FiMtximXLY8xoADfbe=q@mail.gmail.com>
 <25B60CDC2F704E4E9D88FFD52780CB4C0597FEB568@SC-VEXCH1.marvell.com>
 <AANLkTimjKThiuNPhVyOh-SL1e7Zwu2R8Sd2DXAFixpY+@mail.gmail.com> <1281963920.21549.81.camel@localhost>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Mon, 16 Aug 2010 21:55:12 +0800
Message-ID: <AANLkTikCO505BZfqQGsRAdLgMa9hBQZ8YS-hJy-1RGg1@mail.gmail.com>
Subject: Re: [PATCH] [MTD] [NAND] pxa3xx: fix timing and cmdset for samsung2GbX8
To: David Woodhouse <dwmw2@infradead.org>
Cc: Haojian Zhuang <hzhuang1@marvell.com>, Lei Wen <leiwen@marvell.com>,
        Axel Lin <axel.lin@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 9:05 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Mon, 2010-08-16 at 20:55 +0800, Eric Miao wrote:
>> On Mon, Aug 16, 2010 at 8:49 PM, Haojian Zhuang <hzhuang1@marvell.com> wrote:
>> > http://lists.infradead.org/pipermail/linux-mtd/2010-July/subject.html
>> >
>> > They're re-posted in July. Please search the subjects in that page. They're totally 29 patches.
>> >
>> > By the way, David, what's the result of review on these patches? We already posted for several times.
>> >
>>
>> I've actually reviewed some of the patches and gave my Ack. For those
>> patches, I think they can be merged early.
>>
>> And overall, they look good. Yet 29 patch in a whole is still a bit too
>> much, would be good to see them logically be separated into several
>> patch series.
>
> You had some criticism of patch #1 in the sequence, and some questions.
>

So they need to be addressed. Lei, could you please come up with
an updated patch?

> I didn't look much harder than that, iirc... although looking back now
> it seems that the rest of your responses to the sequence were largely
> positive.
>
> Are you happy with the first patch, and if so shall I go ahead and
> import the whole sequence with your Acked-By:?
>

I'm generally OK, but still think it would be good to have another around
of review before they can be merged.
