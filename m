Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab2D1Qfi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 12:35:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46749 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981Ab2D1Qfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 12:35:36 -0400
Message-ID: <4F9C1C31.7060507@zytor.com>
Date: Sat, 28 Apr 2012 09:34:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: RFC: How to handle function tracing, frame pointers and -mfentry?
References: <1335552399.28106.228.camel@gandalf.stny.rr.com> <20120428083603.GJ27374@one.firstfloor.org>
In-Reply-To: <20120428083603.GJ27374@one.firstfloor.org>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2012 01:36 AM, Andi Kleen wrote:
> 
> Kconfig just needs to learn how to run the target compiler
> 
> I think that's the right direction. Right now our main
> Makefiles get polluted more and more with "test compiles", each
> of which makes a "null make" slower and slower. 
> 
> I just measured and a null compile (nothing changes) of a current
> tree calls "gcc" 141 times.
> 
> All this stuff should be cached in the Kconfig instead.
> 
> It may break some obscure setups (that can be probably fixed without
> too much effort), but the development turnaround improvement
> for everyone else would be worth it.
> 

I don't think it is a performance issue as much as a utility issue.
When Kconfig can't actually reflect what is built into the resulting
kernel, that is a problem.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

