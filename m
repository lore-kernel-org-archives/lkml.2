Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab2DNLjI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 07:39:08 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46040 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab2DNLjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 07:39:05 -0400
Date: Sat, 14 Apr 2012 13:38:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alessandro Rubini <rubini@gnudd.com>, mingo@elte.hu,
        akpm@linux-foundation.org, jbarnes@virtuousgeek.org,
        fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        giancarlo.asnaghi@st.com, alan@linux.intel.com
Subject: Re: [PATCH V4 1/3] x86: introduce CONFIG_X86_DEV_DMA_OPS
Message-ID: <20120414113859.GE24688@gmail.com>
References: <4F87388C.300@zytor.com>
 <4F87186B.9010303@zytor.com>
 <cover.1331622735.git.rubini@gnudd.com>
 <5965c5b1f828732b3599131fb21070aba6f1a386.1331622735.git.rubini@gnudd.com>
 <20120314065614.GB27480@elte.hu>
 <20120412201533.GA26533@mail.gnudd.com>
 <20120412203220.GA27629@mail.gnudd.com>
 <4F873F7F.5080001@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F873F7F.5080001@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 04/12/2012 01:32 PM, Alessandro Rubini wrote:
> >>
> >> Not as a compile-time patch.
> > 
> > Why not? CONFIG_ISA is a compile-time choice. I thought that if you
> > compile for non-ISA systems you may reuse the zone mechanism with a
> > different split.
> > 
> > But if not a compile-time thing, would you accept it at run time?
> > I feel it's not a beautiful approach, because it must clearly be
> > masked by #ifndef CONFIG_ISA or such. Worse, you must know the zone
> > split at the beginning, before you scan the PCI bus and find your
> > devices.
> > 
> 
> Compile-time is unacceptable, because it breaks the "one 
> kernel image" policy we have on x86.  So it should be done at 
> runtime.

Agreed. CONFIG_ISA is an old mistake - we try not to repeat old 
mistakes.

Thanks,

	Ingo
