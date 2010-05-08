Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab0EHIJt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 04:09:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47736 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab0EHIJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 04:09:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oli99Fl5oIs3qDzKWqYFDY+p/bEpsD2YRcOrwcSrK1pqNFdWwPF7H5F14yLEfwpV1g
         x8wUpmXCGJCRbQYRUdTdczcMHff1LU3jge/Nvravdo7GYBd/9D1641siKxapc4pzqzl7
         YH2BnyeM5ju9BXut1Or0hpZnkkt+7bjmVA9+U=
Date: Sat, 8 May 2010 12:09:35 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH -tip] x86,perf: P4 PMU -- protect sensible procedures
	from preemption
Message-ID: <20100508080935.GA5333@lenovo>
References: <20100507150517.GB16434@lenovo> <20100508080640.GE2825@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100508080640.GE2825@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 08, 2010 at 10:06:40AM +0200, Ingo Molnar wrote:
> 
> * Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> 
> >  arch/x86/kernel/cpu/perf_event_p4.c |    8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> Looks good - but it doesnt apply cleanly to tip:master:
> 
>  Hunk #3 succeeded at 828 with fuzz 2 (offset 373 lines).
>  Hunk #4 FAILED at 743.
>  1 out of 4 hunks FAILED -- rejects in file arch/x86/kernel/cpu/perf_event_p4.c
> 
> is there some other patch dependency?
> 
> Thanks,
> 
> 	Ingo
> 

No, no deps, I think it's merging clash. Will update it shortly.

	-- Cyrill
