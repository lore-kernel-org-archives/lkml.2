Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab0FCTvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 15:51:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36073 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354Ab0FCTvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 15:51:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hP/NMGvOUQ10dsLI64eB1QmicTyX/rwgxDFv7zpb2xekUMDBLiuD3JL3qsujvvAm82
         Kcx2xnymCPS73K03zwDLBSgLpVGxhghdnDL4HJ9T/AQO5ezW4Z1eo+0bllQlidRUya2E
         nMcOr1YuWZqLS7pj319Bb0s9UYjNpPAnFkBLo=
Date: Thu, 3 Jun 2010 21:52:00 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: make save_stack_address()
	!CONFIG_FRAME_POINTER friendly
Message-ID: <20100603195157.GC5234@nowhere>
References: <20100603193239.GA31530@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603193239.GA31530@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 09:32:39PM +0200, Oleg Nesterov wrote:
> If CONFIG_FRAME_POINTER=n, print_context_stack() shouldn't neglect the
> non-reliable addresses on stack, this is all we have if dump_trace(bp)
> is called with the wrong or zero bp.
> 
> For example, /proc/pid/stack doesn't work if CONFIG_FRAME_POINTER=n.
> 
> This patch obviously has no effect if CONFIG_FRAME_POINTER=y, otherwise
> it reverts 1650743c "x86: don't save unreliable stack trace entries".
> 
> Also, remove the unnecessary type-cast.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

