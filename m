Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab1J0Fyt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 01:54:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43979 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475Ab1J0Fys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 01:54:48 -0400
Message-ID: <4EA8F216.30807@zytor.com>
Date: Thu, 27 Oct 2011 07:54:30 +0200
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Alessandro Rubini <rubini@gnudd.com>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, giancarlo.asnaghi@st.com
Subject: Re: x86/Kconfig: where to place a new chipset
References: <20111027011737.GA17910@mail.gnudd.com>
In-Reply-To: <20111027011737.GA17910@mail.gnudd.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2011 03:17 AM, Alessandro Rubini wrote:
> Hello.
> 
> I'm currently working on a PCIe chipset (or IO-Hub), called STA2X11.
> The device hosts a number of peripherals (sata, ether, spi, uart, ...)
> and a DMA controller.  The individual PCI functions can't be enabled
> by themselves, as chip support must be activated first.  This is both
> because some internal mappings must be setup and because internal
> device functions rely on the internal DMA engine. Actually, an
> instance of swiotlb is being used.
> 
> While I'm sure core code should be in arch/x86/platform (and there is
> where I placed the initialization code), I'm wondering where should
> the device fall in the Kconfig tree. I tend to put it in the
> X86_32_NON_STANDARD stanza, even if the resulting kernel will also
> work on standard computers (the "SGI Visual Workstation" config option
> does the same).
> 
> On the other hand, the device can either be the core chipset (main use
> case) or it can be plugged on a PCIe board.
> 

The nonstandard platform location seems fine to me.

	-hpa

