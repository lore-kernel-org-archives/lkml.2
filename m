Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361Ab2DKKUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 06:20:45 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:62241 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755212Ab2DKKUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 06:20:43 -0400
Date: Wed, 11 Apr 2012 12:19:47 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: mingo@elte.hu
Cc: akpm@linux-foundation.org, jbarnes@virtuousgeek.org,
        fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        giancarlo.asnaghi@st.com, alan@linux.intel.com
Subject: Re: [PATCH V4 1/3] x86: introduce CONFIG_X86_DEV_DMA_OPS
Message-ID: <20120411101947.GA14244@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <20120314065614.GB27480@elte.hu>
References: <20120314065614.GB27480@elte.hu>
  <cover.1331622735.git.rubini@gnudd.com>
  <5965c5b1f828732b3599131fb21070aba6f1a386.1331622735.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alessandro Rubini:
>> 32-bit x86 systems may need their own DMA operations, so add a 
>> new config option, which is turned on for 64-bit systems. This 
>> patch has no functional effect but it paves the way for 
>> supporting the STA2x11 I/O Hub and possibly other chips.
>> 
>> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
>> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
>> Cc: Alan Cox <alan@linux.intel.com>
>> ---
>>  arch/x86/Kconfig                   |    5 +++++
>>  arch/x86/include/asm/device.h      |    4 ++--
>>  arch/x86/include/asm/dma-mapping.h |    2 +-
>>  3 files changed, 8 insertions(+), 3 deletions(-)

Ingo Molnar:
> Ok, the whole series looks pretty clean, modulo a few mostly 
> cosmetic details in the driver itself.
> 
> Andrew, you are typically merging dma-mapping.h patches, would 
> you like to do these, or can we do it in tip:x86/platform?
> 
> It would also be nice if the gents on Cc: would voice objections 
> or approval, if any.

Any news? My next version (V5) I sent on Apr 4th is still working with
today's next, but I got no ack nor nack.

thanks
/alessandro
