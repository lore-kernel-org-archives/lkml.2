Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814Ab1EFVYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 17:24:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932663Ab1EFVYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 17:24:39 -0400
MIME-Version: 1.0
In-Reply-To: <1304716255.25414.2540.camel@gandalf.stny.rr.com>
References: <4DC45537.6070609@linux.intel.com>
	<1304713252.25414.2532.camel@gandalf.stny.rr.com>
	<BANLkTim9YvResB+PwRp7QTK-a5VNg2PvmQ@mail.gmail.com>
	<1304716255.25414.2540.camel@gandalf.stny.rr.com>
Date: Fri, 6 May 2011 14:24:05 -0700
Message-ID: <BANLkTi=KVXjKR82sqsz4gwjr+E0vtqCmvA@mail.gmail.com>
Subject: Re: Fix powerTOP regression with 2.6.39-rc5
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/6/11, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2011-05-06 at 13:51 -0700, Linus Torvalds wrote:
>> On Fri, May 6, 2011 at 1:20 PM, Steven Rostedt <rostedt@goodmis.org>
>
> Um, this is an internal tracepoint. Does this mean that all internal
> data inside the kernel that is exported with trace events are locked
> down?

 it's clearly NOT an internal tracepoint. By definition. It's being
used by powertop.

What part of "reality" vs "your wishes" didn't you understand?

               Linus

>
>>
>> I
