Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658Ab1JRRxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 13:53:06 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:55756 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab1JRRxE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 13:53:04 -0400
MIME-Version: 1.0
In-Reply-To: <20111018173521.GF30644@flint.arm.linux.org.uk>
References: <0CE8B6BE3C4AD74AB97D9D29BD24E55202321E20@CORPEXCH1.na.ads.idt.com>
	<CAJe_ZhfWcUY2ctUFt0iUf2FOfjKj1Aa8hQH5LqFG+bZ+93CcNQ@mail.gmail.com>
	<0CE8B6BE3C4AD74AB97D9D29BD24E55202321F65@CORPEXCH1.na.ads.idt.com>
	<CAJe_ZhfTg17YgyQ9TuKdhtXMu+8W_E2t3cBqZybfarxWu9Zasg@mail.gmail.com>
	<0CE8B6BE3C4AD74AB97D9D29BD24E552023220AC@CORPEXCH1.na.ads.idt.com>
	<CAJe_ZhdBSxvH6Zd8JsoLrerapNbLn0a7Lv6KxwivbFuLaSavyg@mail.gmail.com>
	<20111018074211.GA13483@flint.arm.linux.org.uk>
	<CAJe_ZhdHcsBNT6iX7TJCqoGZMrPwE2BOt06e8M8PHzuDe3Z70w@mail.gmail.com>
	<20111018094944.GA30644@flint.arm.linux.org.uk>
	<0CE8B6BE3C4AD74AB97D9D29BD24E55202367258@CORPEXCH1.na.ads.idt.com>
	<20111018173521.GF30644@flint.arm.linux.org.uk>
Date: Tue, 18 Oct 2011 23:23:03 +0530
Message-ID: <CAJe_Zhcrm_oQhU-RO970r1VN7LroNi8sAfRyQQP0M-QCC9V_UQ@mail.gmail.com>
Subject: Re: [PATCHv4] DMAEngine: Define interleaved transfer request api
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Russell King <rmk@arm.linux.org.uk>
Cc: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Barry Song <21cnbao@gmail.com>,
        linux-kernel@vger.kernel.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
        Dave Jiang <dave.jiang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 October 2011 23:05, Russell King <rmk@arm.linux.org.uk> wrote:
>
> However, Jassi's suggestion that we redefine dma_addr_t to be 64-bit
> for just the DMA engine code is utterly insane and unworkable.  We
> can't have typedefs which change depending on which bits of code are
> being built, potentially changing the layout of structures being passed
> around inside the kernel.
>
I am not sure you understood what I meant.
When I said
     "Perhaps simply change dma_addr_t to u64 in dmaengine.h alone"
I meant
      s/dma_addr_t/u64
