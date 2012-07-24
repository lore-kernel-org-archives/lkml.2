Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab2GXJJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 05:09:04 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40664 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752209Ab2GXJJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 05:09:00 -0400
Date: Tue, 24 Jul 2012 10:08:41 +0100
From: Will Deacon <will.deacon@arm.com>
To: Cyril Chemparathy <cyril@ti.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nico@linaro.org" <nico@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [RFC 00/23] Introducing the TI Keystone platform
Message-ID: <20120724090841.GA16435@mudshark.cambridge.arm.com>
References: <1343092165-9470-1-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343092165-9470-1-git-send-email-cyril@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cyril,

Thanks for this, certainly looks like an interesting platform!

Of course, in order to perform any sort of sensible review, I'll need some
silicon to test it on :)

On Tue, Jul 24, 2012 at 02:09:02AM +0100, Cyril Chemparathy wrote:
> TI's scalable KeyStone II architecture includes support for both TMS320C66x
> floating point DSPs and ARM Cortex-A15 clusters, for a mixture of up to 32
> cores per SoC.  The solution is optimized around a high performance chip
> interconnect and a rich set of on chip peripherals.  Please refer [1] for
> initial technical documentation on these devices.

How many A15s can you have on such a SoC? It wasn't clear whether it was 1x4
or 4x4 from the documentation.

> This patch series provides a basic Linux port for these devices, including
> support for SMP, and LPAE boot.  A majority of the patches in this series are
> related to LPAE functionality, imposed by the device architecture which has
> system memory mapped at an address above the 4G 32-bit addressable limit.

I assume you have *some* memory in the bottom 32-bits though, right? Even if
it's just a partial alias of a higher bank.

> This patch series is based on the v3.5 kernel with the smp_ops patch set
> applied on top.  This series is being posted to elicit early feedback, and so
> that some of these fixes may get incorporated early on into the kernel code.
> 
>   [1] - http://www.ti.com/product/tms320tci6636

This is marked as `TI confidential' but I guess that's an oversight [or will
you have to kill me?].

Will
