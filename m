Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932720Ab1EFUwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 16:52:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51435 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932654Ab1EFUwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 16:52:23 -0400
MIME-Version: 1.0
In-Reply-To: <1304713252.25414.2532.camel@gandalf.stny.rr.com>
References: <4DC45537.6070609@linux.intel.com> <1304713252.25414.2532.camel@gandalf.stny.rr.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 May 2011 13:51:29 -0700
Message-ID: <BANLkTim9YvResB+PwRp7QTK-a5VNg2PvmQ@mail.gmail.com>
Subject: Re: Fix powerTOP regression with 2.6.39-rc5
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

On Fri, May 6, 2011 at 1:20 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> I strongly NACK this!

Doesn't matter.

Binary compatibility is more important.

And if binaries don't use the interface to parse the format (or just
parse it wrongly - see the fairly recent example of adding uuid's to
/proc/self/mountinfo), then it's a regression.

And regressions get reverted, unless there are security issues or
similar that makes us go "Oh Gods, we really have to break things".

I don't understand why this simple logic is so hard for some kernel
developers to understand. Reality matters. Your personal wishes matter
NOT AT ALL.

If you made an interface that can be used without parsing the
interface description, then we're stuck with the interface. Theory
simply doesn't matter.

You could help fix the tools, and try to avoid the compatibility
issues that way. There aren't that many of them.

                         Linus
