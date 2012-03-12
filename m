Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab2CLTr3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 15:47:29 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44537 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756440Ab2CLTr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 15:47:28 -0400
MIME-Version: 1.0
In-Reply-To: <1331520476.4657.79.camel@vkoul-udesk3>
References: <1331101687.24656.319.camel@vkoul-udesk3>
	<Pine.LNX.4.64.1203070917380.19595@axis700.grange>
	<20120307093026.GM17370@n2100.arm.linux.org.uk>
	<Pine.LNX.4.64.1203071041030.19595@axis700.grange>
	<20120307103112.GP17370@n2100.arm.linux.org.uk>
	<Pine.LNX.4.64.1203071149190.19595@axis700.grange>
	<20120307124620.GT17370@n2100.arm.linux.org.uk>
	<Pine.LNX.4.64.1203071416060.19595@axis700.grange>
	<20120307142634.GA18787@n2100.arm.linux.org.uk>
	<Pine.LNX.4.64.1203071602330.19595@axis700.grange>
	<20120307162755.GB18787@n2100.arm.linux.org.uk>
	<Pine.LNX.4.64.1203071906040.19595@axis700.grange>
	<1331188201.4657.51.camel@vkoul-udesk3>
	<Pine.LNX.4.64.1203080902170.29847@axis700.grange>
	<1331204128.4657.54.camel@vkoul-udesk3>
	<Pine.LNX.4.64.1203081200170.29847@axis700.grange>
	<1331206459.4657.59.camel@vkoul-udesk3>
	<1331211513.4657.67.camel@vkoul-udesk3>
	<Pine.LNX.4.64.1203081412550.29847@axis700.grange>
	<1331284918.4657.69.camel@vkoul-udesk3>
	<Pine.LNX.4.64.1203091022200.7852@axis700.grange>
	<1331285959.4657.76.camel@vkoul-udesk3>
	<Pine.LNX.4.64.1203091049060.7852@axis700.grange>
	<1331520476.4657.79.camel@vkoul-udesk3>
Date: Mon, 12 Mar 2012 20:47:27 +0100
Message-ID: <CACRpkdbS5P9DsCWYHcw8n-7EYUX6q=GaUdrDF99Zx12j0-mU8A@mail.gmail.com>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to __dma_request_channel()
From: Linus Walleij <linus.walleij@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Jassi Brar <jassisinghbrar@gmail.com>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 3:47 AM, Vinod Koul <vinod.koul@intel.com> wrote:
> On Fri, 2012-03-09 at 13:20 +0100, Guennadi Liakhovetski wrote:
>> It can be made to work as long as there's only one DMAC group with
>> configurable channels and all other DMACs are dedicated to specific
>> peripherals, yes. I don't know whether there are already now or are
>> approaching any platforms with multiple reconfigurable groups.
>
> And that is what I am talking about.
>
> Having specific channel mapping given by platform for all channels which
> are to be used dedicated. And a pool of channels which can be used by
> anyone (if they can be) on a platform.
>
> Does this proposal sound good for others as well.

It sounds good to me.

Yours,
Linus Walleij
