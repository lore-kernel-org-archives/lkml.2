Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab0GNJWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 05:22:05 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47835 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab0GNJWD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 05:22:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IVaJePl4JHWK8BWVoLM75V51a8kempCGInRCIXLNmxorzHHxicl66me8gjCen76zpI
         d/oH6m0v/ZS2Wn0NrXRzz9qcS+wfaWAB3GTZX93lkw8mwdWVdm44YN8n5dv4otO28UrM
         sqPrtH4VOKTlSPu8Ts3UcqdzHTvlNff2mSA9g=
MIME-Version: 1.0
In-Reply-To: <20100712200604.GD9897@n2100.arm.linux.org.uk>
References: <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
	<20100603181010.GA25779@flint.arm.linux.org.uk>
	<1275589230.23384.19.camel@c-dwalke-linux.qualcomm.com>
	<alpine.LFD.2.00.1006031119440.8175@i5.linux-foundation.org>
	<20100614083214.GA2104@pengutronix.de>
	<20100630104043.GG11746@pengutronix.de>
	<20100712155518.GA24144@pengutronix.de>
	<AANLkTilhI9O6YwnuAylo_jNgwR8VXmpSVJ1kylIYPCGT@mail.gmail.com>
	<20100712173228.GC9897@n2100.arm.linux.org.uk>
	<AANLkTinxUqzxClVDTyruJ6kzFTganXUGJJHJ5wRi9Iak@mail.gmail.com>
	<20100712200604.GD9897@n2100.arm.linux.org.uk>
Date: Wed, 14 Jul 2010 12:21:59 +0300
Message-ID: <AANLkTincDKhGYRzFJlK5ovtygTfjJVQDvXYZlITAsmT7@mail.gmail.com>
Subject: Re: ARM defconfig files
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Daniel Walker <dwalker@codeaurora.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Eric Miao <eric.miao@canonical.com>, linux-omap@vger.kernel.org,
        Nicolas Pitre <nico@fluxnic.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 11:06 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Jul 12, 2010 at 10:40:36AM -0700, Linus Torvalds wrote:
>> On Mon, Jul 12, 2010 at 10:32 AM, Russell King - ARM Linux
>> <linux@arm.linux.org.uk> wrote:
>> >
>> > When you brought up the problem you seemed absolutely convinced
>> > that nothing except your solution was going to be acceptable.
>>
>> That's not true. What's true is that you didn't seem to _understand_
>> my solution, so I tried to push the understanding of it.
>
> That's your point of view.
>
> My viewpoint was that I had read your email, thought of some alternative
> solution, proposed it and the result was shot down without any apparant
> thought about it.  That gave the impression that you _only_ wanted to
> see your own solution.

I think you got it wrong. Linus liked my proposal of minimal
defconfigs, and the only discrepancy was on the format:
http://article.gmane.org/gmane.linux.kernel/995419

-- 
Felipe Contreras
