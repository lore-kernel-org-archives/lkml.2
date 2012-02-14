Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab2BNQ2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 11:28:54 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42438 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab2BNQ2x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 11:28:53 -0500
MIME-Version: 1.0
X-Originating-IP: [108.60.121.130]
In-Reply-To: <4F391C1D.9020402@monstr.eu>
References: <4F1EE861.4030405@monstr.eu> <CAK=Wgba5kT8AwLtuHyosucYnWf-EA+xpE1kzmssfhSC7ZXQA=g@mail.gmail.com>
 <4F1FF870.3000105@monstr.eu> <CAK=WgbZwaxMPsMiNcq5yFvBLrcODqGgDT6b=mmQ91JBVtTEyXA@mail.gmail.com>
 <4F200F64.9060203@monstr.eu> <CAK=WgbZDADRf1OF=uWbbsF+t2dx36tqj=kRftn5nd4RA7DtEnA@mail.gmail.com>
 <4F212E9E.9060807@monstr.eu> <CAK=WgbYMBDp3Qm8TErNrnDwn2ZTFt62+OuyyQvVE-jrnNsL6kg@mail.gmail.com>
 <4F391C1D.9020402@monstr.eu>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 14 Feb 2012 17:28:33 +0100
Message-ID: <CAK=WgbYn6hrS4YLEdfp=0jSEfEwy-HkJmt5S06_j6gZFf0UTmQ@mail.gmail.com>
Subject: Re: remoteproc: Load coprocessor code to the specific main memory location
To: monstr@monstr.eu
Cc: LKML <linux-kernel@vger.kernel.org>,
        John Williams <john.williams@petalogix.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "Grosen, Mark" <mgrosen@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 3:20 PM, Michal Simek <monstr@monstr.eu> wrote:
> Here is how it is achieve
>        ret = dma_declare_coherent_memory(&zynq_freertos.dev, 0,
>                                0, 0x10000000, DMA_MEMORY_MAP);
>
> which is fully compatible with remoteproc.

Great, this is what we've been doing with davinci too.

> Do you have any example of using it?

What exactly are you looking for ? RTOS or Linux side ?

On the Linux side, you can just make the rpmsg sample work (it's part
of the rpmsg patch set). For the RTOS side, feel free to just take our
code (it's BSD licensed and hosted on github) and adapt it to your
environment.

Ohad.
