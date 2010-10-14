Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab0JNAsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 20:48:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48612 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754083Ab0JNAr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 20:47:57 -0400
Date: Wed, 13 Oct 2010 17:47:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Feng Tang <feng.tang@intel.com>
Subject: Re: linux-next: Tree for October 13
Message-Id: <20101013174740.f48e4ec2.akpm@linux-foundation.org>
In-Reply-To: <4CB651A4.60205@zytor.com>
References: <20101013154522.7b087a20.sfr@canb.auug.org.au>
	<20101013173826.f4b911b4.akpm@linux-foundation.org>
	<4CB651A4.60205@zytor.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Oct 2010 17:41:08 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 10/13/2010 05:38 PM, Andrew Morton wrote:
> > On Wed, 13 Oct 2010 15:45:22 +1100
> > Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > 
> >> I have created today's linux-next tree at
> >> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> > 
> > In an i386 allmodconfig build, compilation of
> > arch/x86/kernel/early_printk_mrst.c is emitting a call to
> > __this_fixmap_does_not_exist().  
> 
> Will look at it.  Do you happen to have toolchain versions?
> 

gcc-4.1.0.  Which is actually an officially banned compiler version:

 # if __GNUC_MINOR__ == 1 && __GNUC_PATCHLEVEL__ <= 1
 #  error Your version of gcc miscompiles the __weak directive

lazyass here needs to find a new cross-compiler.
