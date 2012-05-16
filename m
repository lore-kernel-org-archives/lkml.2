Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965501Ab2EPUAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 16:00:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28602 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964985Ab2EPUAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 16:00:05 -0400
X-Authority-Analysis: v=2.0 cv=OMylLFmB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=XlIr_nCh6zIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=MWxpP3UV4SJqTqjMdnwA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337198404.6724.81.camel@gandalf.stny.rr.com>
Subject: Re: [RFC][PATCH] tracing: Remove useless 4 bytes of padding from
 every event
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 16 May 2012 16:00:04 -0400
In-Reply-To: <CA+55aFzVngkixn-t0mK8QqgnPhCzN2AsUtzfZ3BkLiJAcjNOzQ@mail.gmail.com>
References: <1337175871.6724.46.camel@gandalf.stny.rr.com>
	 <CA+55aFzVngkixn-t0mK8QqgnPhCzN2AsUtzfZ3BkLiJAcjNOzQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 12:33 -0700, Linus Torvalds wrote:

> F16 and F17 seem to have powertop-1.98, which I assume is the new
> world order already. But maybe I assume incorrectly.

Seriously though. What's your take on changing the kernel that will
break an older distro. Obviously, this change is too early to apply. But
because an old distro has one app that will break if we make a change in
the kernel, is that enough to keep that change out?

Lets say we are at F23, and F18+ have the new powertop tools. Lets even
go to say that F16 and F17 have updated their powertop to powertop v2.

Because someone may be running a F17 without updates, which has powertop
that will break if they update their kernel, rational to keeping that
change out?

I want to know if this change will ever go in. Otherwise, I have to make
workarounds for it. I have no problem with that, as I will be adding
workarounds anyway, but this will continue to punish the tools that use
the non-workaround methods even though they don't break with the change.

Now if you say that it's OK to break and old distro if the affected
tools in the new distros work. What's the timeframe of that? One year?

-- Steve


