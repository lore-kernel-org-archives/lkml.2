Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab1AGPYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 10:24:35 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51230 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885Ab1AGPYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 10:24:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fE8gt0EbW7JJ41tVjq2lZ7u69YN86Ym0QODwqoCpoCpePZc966vs/ZUdGkLWUIHwF5
         iyBKkFBkoKVLhzoZCAtf7zx1pPe4KHMJ2+onWW6BYLfezLBrGf3RVxEDCjeoWHpyngP4
         YltUE3QBK9vkAnEDuEDNAPA/AMY8TI2YgR590=
Date: Fri, 7 Jan 2011 16:24:29 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Soeren Sandmann Pedersen <sandmann@redhat.com>
Subject: Re: [RFC GIT PULL] perf updates
Message-ID: <20110107152421.GA2631@nowhere>
References: <1294325513-14276-1-git-send-email-fweisbec@gmail.com>
 <20110107122317.GA20761@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110107122317.GA20761@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 01:23:17PM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Ingo,
> > 
> > Please pull the perf/core branch that can be found at:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> > 	perf/core
> > 	
> > Soeren reported some time ago that callchains were broken on
> > x86_64 with cpu-clock/task-clock events. After some time I
> > finally found the problem was in the irq low level arg saving.
> > It touches fragile code though, I hope some people can
> > have a look over the fix.
> > 
> > Thanks,
> > 	Frederic
> > ---
> > 
> > Frederic Weisbecker (2):
> >       x86: Fix rbp saving in pt_regs on irq entry
> >       perf: Build tools with frame pointer
> 
> Is this variant fine with Jan too?

So, Arnaldo has picked up the second patch.

For the first I need to resend with a fix on CFI annotations.
