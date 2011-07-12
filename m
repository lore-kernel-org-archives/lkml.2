Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab1GLLJe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 07:09:34 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:53885 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab1GLLJd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 07:09:33 -0400
MIME-Version: 1.0
In-Reply-To: <E0D41E29EB0DAC4E9F3FF173962E9E94030259DB5B@dbde02.ent.ti.com>
References: <1310310203-12288-1-git-send-email-sundaram@ti.com>
	<CABb+yY1HJOR+QzmM4-ju4cs+8keoyUbMv+SpVoM6BW=DCMzmQQ@mail.gmail.com>
	<CACRpkdbLg0+_2kpi4NizFj0fDWb6QPtkcKirKgoH+83vGD0O0A@mail.gmail.com>
	<E0D41E29EB0DAC4E9F3FF173962E9E94030259DB5B@dbde02.ent.ti.com>
Date: Tue, 12 Jul 2011 13:09:31 +0200
Message-ID: <CACRpkdYk65dmgvy325EA0rFEL3sZXMzNBvPBLGxctjQsfZhCBg@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: add dma_ctrl_cmd to pass buffer stride configuration
From: Linus Walleij <linus.walleij@linaro.org>
To: "Raju, Sundaram" <sundaram@ti.com>
Cc: Jassi Brar <jassisinghbrar@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 12:56 PM, Raju, Sundaram <sundaram@ti.com> wrote:
> [Me]
>> [Jassi]
>> > 3) TI may not have just one DMAC IP used in all the SoCs. So if you want
>> >  vendor specific defines anyway, please atleast also add DMAC version to it.
>> >  Something like
>> >>        DMA_SLAVE_CONFIG,
>> >>        FSLDMA_EXTERNAL_START,
>> >> +       TI_DMA_v1_STRIDE_CONFIG,
>>
>> Yep unless we make it generic DMA_STRIDE_CONFIG simply, this makes
>> a lot of sense.
>
> Okay, I can add one cmd for the EDMAC in DaVinci series of SoCs and
> one for SDMAC in OMAP series of SoCs.

Wait, that's two different silicon blocks right? Then you already have proof
that this spans more than one DMAC and then you can just go for a generic
DMA_STRIDE_CONFIG from day one.

That both are TI does not matter, if they are totally unrelated implementations.

Yours,
Linus Walleij
