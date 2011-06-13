Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab1FMUCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 16:02:14 -0400
Received: from smtp-out.google.com ([74.125.121.67]:21823 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab1FMUCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 16:02:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=ozzBovoZ2jtKQIZkc30Kk9dNKqc2Umfp8Y07ymlp5C5uDjsZt22POIPXPYXdHk6GMw
         IGkzd89EMV57jCiUe+ag==
MIME-Version: 1.0
In-Reply-To: <1307966043.9218.63.camel@gandalf.stny.rr.com>
References: <20110609172744.333794089@goodmis.org> <20110609172910.950101158@goodmis.org>
 <20110613101248.GC30962@elte.hu> <1307965185.9218.53.camel@gandalf.stny.rr.com>
 <20110613114904.GD10960@elte.hu> <1307966043.9218.63.camel@gandalf.stny.rr.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Mon, 13 Jun 2011 13:01:39 -0700
Message-ID: <BANLkTikssQhJu3t=ikpbq11oGeV2D3L-Zc1TuVW0+TKBqmkXyw@mail.gmail.com>
Subject: Re: [PATCH 03/15] tracing: Add a free on close control mechanism for buffer_size_kb
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 4:54 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2011-06-13 at 13:49 +0200, Ingo Molnar wrote:
>
>> > https://lkml.org/lkml/2011/3/17/366
>> >
>> > I didn't really like adding another file to the debugfs system, and
>> > recommended the ioctl. It seemed like a nice "unix" fit. But if you
>> > want to go back to the Vaibhav's original method, which will stay
>> > in the frame of "human-parseable and scripted". We could do that.
>>
>> Yes, i think so - the *only* point of the /debug/tracing/ muck is
>> that it's scriptable and human parseable. If Google wants to use it
>> for more than that then they should help us enhance the perf syscall
>> ABI for tracing ...
>
> Hi Vaibhav,
>
> Sorry for the spin around, but could you resubmit your original patch?
>
> Thanks!
>
> -- Steve
>

Hi Steven

I have created the patch.

I was wondering what would you consider a good name for the new proc
file? David suggested "free_ring_buffer".


Vaibhav Nagarnaik
