Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab2CWInO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 04:43:14 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60322 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab2CWInJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 04:43:09 -0400
Date: Fri, 23 Mar 2012 09:43:04 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Chris Zankel <chris@zankel.net>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] config: simplify INLINE_SPIN_UNLOCK
Message-ID: <20120323084304.GD2886@gmail.com>
References: <20120322095502.30866.75756.sendpatchset@codeblue>
 <4F6C170A.4070305@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F6C170A.4070305@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com> wrote:

> On 03/22/2012 03:25 PM, Raghavendra K T wrote:
> >From: Raghavendra K T<raghavendra.kt@linux.vnet.ibm.com>
> >
> >Patch simplifies current INLINE_SPIN_UNLOCK. compile tested on x86_64
> >
> >Change log:
> >get rid of INLINE_SPIN_UNLOCK entirely replacing it with UNINLINE_SPIN_UNLOCK
> >instead with the reverse meaning.
> >
> >whover wants to uninline the spinlocks (like spinlock debugging, paravirt etc
> >all just do select UNINLINE_SPIN_UNLOCK
> typo:
> Whoever wants to uninline the spinlocks (like spinlock debugging,
> paravirt etc) just do select UNINLINE_SPIN_UNLOCK.
> 
> >
> >Suggested-by: Linus Torvalds<torvalds@linux-foundation.org>
> >Signed-off-by: Raghavendra K T<raghavendra.kt@linux.vnet.ibm.com>
> >---
> >  Please refer : https://lkml.org/lkml/2012/3/21/357
> 
> Linus, Please let me know if this is what you were looking for or
> Did I really mess it up :(

Looks sane to me at first sight - will process it once the merge 
window calms down a bit.

Thanks,

	Ingo
