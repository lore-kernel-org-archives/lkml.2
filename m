Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab0FWXx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 19:53:27 -0400
Received: from ozlabs.org ([203.10.76.45]:53534 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532Ab0FWXxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 19:53:25 -0400
Date: Thu, 24 Jun 2010 09:53:09 +1000
From: Paul Mackerras <paulus@samba.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: Hitting WARN_ON in hw_breakpoint code
Message-ID: <20100623235309.GA17441@brick.ozlabs.ibm.com>
References: <20100623125740.GA3368@brick.ozlabs.ibm.com>
 <20100623174918.GH5242@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100623174918.GH5242@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 07:49:20PM +0200, Frederic Weisbecker wrote:

> Indeed. I'm suprised I've never seen this problem before while the
> bug is quite obvious.
> 
> Anyway I'm cooking a fix, thanks for this report!

If you haven't been seeing it on x86, I think I'll look a bit closer.
I would have thought that the perf_event would have a reference to the
context, so the context shouldn't have gone away while the perf_event
still exists.  It may be something we're doing differently on ppc64.

Paul.
