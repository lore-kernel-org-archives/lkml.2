Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab1HFCFc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 22:05:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36974 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017Ab1HFCFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 22:05:31 -0400
Message-ID: <4E3CA12D.1030408@zytor.com>
Date: Fri, 05 Aug 2011 19:04:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Brian Gerst <brgerst@gmail.com>
Subject: Re: [PATCH 0/4 v2] [GIT PULL][v3.2] x86: Consolidate 32 and 64 bit
 thread_info
References: <20110806011102.721109343@goodmis.org>
In-Reply-To: <20110806011102.721109343@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2011 06:11 PM, Steven Rostedt wrote:
> 
> Thomas, Ingo, and Peter(s),
> 
> On IRC, Peter Zijlstra mentioned to me the difference between
> 32bit and 64bit x86 on how thread_info is handled with interrupts.
> I mentioned that they should be more the same, and Peter agreed.
> 
> I decided to do so, and ended up with the following patches.
> I marked this for v3.2 as it should be tested a bit before going into
> mainline. I've ran several configs on it, but more testing should be done.
> 
> Some of the patches are clean ups, but the main ones are patch 3 and 4
> that do the work to convert 32bit of thread_info to be more like
> the 64bit.
> 

Hi Steven,

I'd like to wait until the merge window is over with pulling in 3.2
material ... nothing personal or technical, just to simplify management.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

