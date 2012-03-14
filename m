Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab2CNG4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 02:56:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33455 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab2CNG4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 02:56:39 -0400
Date: Wed, 14 Mar 2012 07:56:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>, Alessandro Rubini <rubini@gnudd.com>
Subject: Re: [PATCH V4 1/3] x86: introduce CONFIG_X86_DEV_DMA_OPS
Message-ID: <20120314065614.GB27480@elte.hu>
References: <cover.1331622735.git.rubini@gnudd.com>
 <5965c5b1f828732b3599131fb21070aba6f1a386.1331622735.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5965c5b1f828732b3599131fb21070aba6f1a386.1331622735.git.rubini@gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alessandro Rubini <rubini@gnudd.com> wrote:

> 32-bit x86 systems may need their own DMA operations, so add a 
> new config option, which is turned on for 64-bit systems. This 
> patch has no functional effect but it paves the way for 
> supporting the STA2x11 I/O Hub and possibly other chips.
> 
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
> Cc: Alan Cox <alan@linux.intel.com>
> ---
>  arch/x86/Kconfig                   |    5 +++++
>  arch/x86/include/asm/device.h      |    4 ++--
>  arch/x86/include/asm/dma-mapping.h |    2 +-
>  3 files changed, 8 insertions(+), 3 deletions(-)

Ok, the whole series looks pretty clean, modulo a few mostly 
cosmetic details in the driver itself.

Andrew, you are typically merging dma-mapping.h patches, would 
you like to do these, or can we do it in tip:x86/platform?

It would also be nice if the gents on Cc: would voice objections 
or approval, if any.

Thanks,

	Ingo
