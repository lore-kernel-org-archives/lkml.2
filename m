Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab0DVIav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 04:30:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:39164 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000Ab0DVIar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 04:30:47 -0400
Message-ID: <4BCED8CD.8040708@kernel.org>
Date: Wed, 21 Apr 2010 12:51:57 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Greg KH <greg@kroah.com>, Steven Rostedt <rostedt@goodmis.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       stable <stable@kernel.org>
Subject: Re: [stable] [PATCH] modules fix incorrect percpu usage
References: <20100330033211.GC7683@Krystal> <20100330033617.GE7683@Krystal> <1269955201.19685.5867.camel@gandalf.stny.rr.com> <20100330135047.GB20673@Krystal> <20100419182822.GH32347@kroah.com> <20100420143457.GB14622@Krystal>
In-Reply-To: <20100420143457.GB14622@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 22 Apr 2010 08:30:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 04/20/2010 04:34 PM, Mathieu Desnoyers wrote:
> Same here, for module.c fix. Feel free to choose between this fix or the
> corresponding refactoring from Tejun.

Please take this one for -stable.  I don't think the percpu
refactoring is worthwhile to backport to -stable.  It only affects
debug feature and the worst outcome is spurious warning messages.

Thanks.

-- 
tejun
