Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab1HSFSt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 01:18:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60586 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab1HSFSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 01:18:48 -0400
References: <20110806011102.721109343@goodmis.org> <4E3CA12D.1030408@zytor.com> <1313719275.15704.79.camel@gandalf.stny.rr.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <1313719275.15704.79.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/4 v2] [GIT PULL][v3.2] x86: Consolidate 32 and 64 bit thread_info
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 18 Aug 2011 22:17:13 -0700
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Brian Gerst <brgerst@gmail.com>
Message-ID: <ab587762-c748-46dc-b137-70c041b46c5c@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> wrote:

>On Fri, 2011-08-05 at 19:04 -0700, H. Peter Anvin wrote:
>> On 08/05/2011 06:11 PM, Steven Rostedt wrote:
>> > 
>> > Thomas, Ingo, and Peter(s),
>> > 
>> > On IRC, Peter Zijlstra mentioned to me the difference between
>> > 32bit and 64bit x86 on how thread_info is handled with interrupts.
>> > I mentioned that they should be more the same, and Peter agreed.
>> > 
>> > I decided to do so, and ended up with the following patches.
>> > I marked this for v3.2 as it should be tested a bit before going
>into
>> > mainline. I've ran several configs on it, but more testing should
>be done.
>> > 
>> > Some of the patches are clean ups, but the main ones are patch 3
>and 4
>> > that do the work to convert 32bit of thread_info to be more like
>> > the 64bit.
>> > 
>> 
>> Hi Steven,
>> 
>> I'd like to wait until the merge window is over with pulling in 3.2
>> material ... nothing personal or technical, just to simplify
>management.
>> 
>> 	-hpa
>> 
>
>Ping?
>
>-- Steve

Travelling last and this week... if Ingo doesn't beat me to it pung me again Tuesday if I haven't grabbed it already....
-- 
Sent from my mobile phone. Please excuse my brevity and lack of formatting.
