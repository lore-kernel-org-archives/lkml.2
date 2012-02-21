Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab2BUUUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 15:20:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962Ab2BUUUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 15:20:30 -0500
Date: Tue, 21 Feb 2012 15:20:19 -0500
From: Jason Baron <jbaron@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, rostedt@goodmis.org,
        mathieu.desnoyers@efficios.com, davem@davemloft.net,
        ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups +
 docs
Message-ID: <20120221202019.GB2381@redhat.com>
References: <cover.1329851692.git.jbaron@redhat.com>
 <4F43F9F0.4000605@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F43F9F0.4000605@zytor.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 12:09:20PM -0800, H. Peter Anvin wrote:
> On 02/21/2012 12:02 PM, Jason Baron wrote:
> > Hi,
> > 
> > Renames 'static_branch()' -> very_unlikely(), hopefully, to be more intuitive
> > as to what jump labels is about. I'm also introducing 'very_likely()', as
> > the analogue to very_unlikely(). Patch is against the -tip perf branch.
> > 
> 
> Erk... I'm not happy about this.  very_unlikely() makes it sound like it
> operates like unlikely(), which really is not the case.  There is a huge
> difference in mechanism here as well as usage.
> 
> 	-hpa
> 

The naming discussion really stems from the addition of a default true
branch.

Originally we had 'static_branch()'. Then, in the first RFC introducing
the default true branch, I proposed: 'static_branch_def_false', and
'static_branch_def_true'. Did you like those better?

I'm not really too hung up on the naming, but I did think that
very_[un]likely were an interesting possibility.

Thanks,

-Jason
