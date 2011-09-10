Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab1IJXc6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 19:32:58 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:61896 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab1IJXc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 19:32:56 -0400
Date: Sun, 11 Sep 2011 08:32:50 +0900
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        dvlasenk@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] ptrace: simplify PTRACE_foo constants and
 PTRACE_SETOPTIONS code
Message-ID: <20110910233250.GC29319@htj.dyndns.org>
References: <201109090822.30063.vda.linux@googlemail.com>
 <201109090824.37366.vda.linux@googlemail.com>
 <201109090829.34222.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109090829.34222.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 08:29:34AM +0200, Denys Vlasenko wrote:
> ptrace: simplify PTRACE_foo constants and PTRACE_SETOPTIONS code
> 
> Exchange PT_TRACESYSGOOD and PT_PTRACE_CAP bit positions, which makes
> PT_option bits contiguous and therefore makes code in ptrace_setoptions()
> much simpler.
> 
> Every PTRACE_O_TRACEevent is defined to (1 << PTRACE_EVENT_event)
> instead of using explicit numeric constants, to ensure we don't
> mess up relationship between bit positions and event ids.
> 
> PT_EVENT_FLAG_SHIFT was not particularly useful, PT_OPT_FLAG_SHIFT with
> value of PT_EVENT_FLAG_SHIFT-1 is easier to use.
> 
> PT_TRACE_MASK constant is nuked, the only its use is replaced by
> (PTRACE_O_MASK << PT_OPT_FLAG_SHIFT).
> 
> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
