Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab2DCUge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 16:36:34 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64551 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab2DCUgd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 16:36:33 -0400
MIME-Version: 1.0
In-Reply-To: <20120330103828.GC22981@n2100.arm.linux.org.uk>
References: <Pine.LNX.4.64.1203091022200.7852@axis700.grange>
	<1331285959.4657.76.camel@vkoul-udesk3>
	<Pine.LNX.4.64.1203091049060.7852@axis700.grange>
	<1331520476.4657.79.camel@vkoul-udesk3>
	<Pine.LNX.4.64.1203161029490.13465@axis700.grange>
	<CACRpkdYiuERV08=UhBRnj2AjC_RxF+EY+zHAtEp6KYf2W10C_Q@mail.gmail.com>
	<Pine.LNX.4.64.1203161128120.13465@axis700.grange>
	<CACRpkdY7ApBc-gbSdf+=7PLtKSMvzYuBi7RNnVgi=vjcd-KvhQ@mail.gmail.com>
	<Pine.LNX.4.64.1203161522570.13465@axis700.grange>
	<CACRpkdbp3EfF-4z2uuy+gLdXvHqUqj+Zmp-GZxhaHv_RxxRKHQ@mail.gmail.com>
	<20120330103828.GC22981@n2100.arm.linux.org.uk>
Date: Tue, 3 Apr 2012 22:36:32 +0200
Message-ID: <CACRpkdam8yJnMjyJG1AZ_W_05oaSvPQ5V7D2nM-2ijr54v4yJg@mail.gmail.com>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to __dma_request_channel()
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 12:38 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Mar 30, 2012 at 07:44:09AM +0200, Linus Walleij wrote:
>> However you're right (in some later mail) that we need to distinguish
>> between RX/TX channels at this point, so I can agree we need some
>> additional parameter, but that should be very abstract, not containing
>> any custom stuff or any void * or something like that.
>
> No you don't.  DMA engines can generally deal with transfers operating in
> either direction on a single channel.

You're right, and I came to think of it out of reach from a computer.
The MMC on the RealViews and U300 indeed works like that.
And there has to be one way of doing this instead of hooking it
in at channel selection time, config-time is it.

Yours,
Linus Walleij
