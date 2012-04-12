Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761265Ab2DLSCB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 14:02:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41540 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab2DLSCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 14:02:00 -0400
Message-ID: <4F87186B.9010303@zytor.com>
Date: Thu, 12 Apr 2012 11:01:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>, Alessandro Rubini <rubini@gnudd.com>
Subject: Re: [PATCH V4 1/3] x86: introduce CONFIG_X86_DEV_DMA_OPS
References: <cover.1331622735.git.rubini@gnudd.com> <5965c5b1f828732b3599131fb21070aba6f1a386.1331622735.git.rubini@gnudd.com> <20120314065614.GB27480@elte.hu>
In-Reply-To: <20120314065614.GB27480@elte.hu>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2012 11:56 PM, Ingo Molnar wrote:
> 
> * Alessandro Rubini <rubini@gnudd.com> wrote:
> 
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
> 
> Ok, the whole series looks pretty clean, modulo a few mostly 
> cosmetic details in the driver itself.
> 
> Andrew, you are typically merging dma-mapping.h patches, would 
> you like to do these, or can we do it in tip:x86/platform?
> 
> It would also be nice if the gents on Cc: would voice objections 
> or approval, if any.
> 

I looked over it, and at least this bit seems okay to me.

Acked-by: H. Peter Anvin <hpa@zytor.com>

Andrew, I guess the question is still open?

I have to express some concern about where this device may be going, though.

	-hpa
