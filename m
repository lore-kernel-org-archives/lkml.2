Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab1JKNRL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 09:17:11 -0400
Received: from mail.windriver.com ([147.11.1.11]:46422 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab1JKNRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 09:17:09 -0400
Date: Tue, 11 Oct 2011 09:16:18 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: build warning after merge of the moduleh tree
Message-ID: <20111011131618.GV19986@windriver.com>
References: <20111011202142.4d18840463055a8bdb9d1590@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111011202142.4d18840463055a8bdb9d1590@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[linux-next: build warning after merge of the moduleh tree] On 11/10/2011 (Tue 20:21) Stephen Rothwell wrote:

> Hi Paul,
> 
> After merging the moduleh tree, today's linux-next build (i386 defconfig)
> produced this warning:
> 
> arch/x86/kernel/cpu/perf_event_intel.c:1323:1: warning: data definition has no type or storage class [enabled by default]
> arch/x86/kernel/cpu/perf_event_intel.c:1323:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]
> arch/x86/kernel/cpu/perf_event_intel.c:1323:1: warning: parameter names (without types) in function declaration [enabled by default]
> 
> Introduced by commit 144d31e6f190 ("perf, intel: Use GO/HO bits in
> perf-ctr") from the tip tree interacting with the module.h slipt up.
> 
> I'll add a patch tomorrow to add an include of export.h to this file.

Hi Stephen,

I've added this and the other nmi export to the post-merge queue.  I'll
assume for the moment that the regulator tree will pick up the 3rd one,
like you recommended.

Thanks,
Paul.

> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/


