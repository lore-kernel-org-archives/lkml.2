Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751263Ab2HIEQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 00:16:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35403 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791Ab2HIEQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 00:16:08 -0400
Message-ID: <50233968.4090805@zytor.com>
Date: Wed, 08 Aug 2012 21:15:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Steven Rostedt <rostedt@goodmis.org>, Michal Marek <mmarek@suse.cz>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC PATCH 3/4] ftrace: Do not test frame pointers if -mfentry
 is used
References: <20120807193845.146666357@goodmis.org> <20120807194059.773895870@goodmis.org> <5021EC6B.7020605@hitachi.com> <1344430148.6935.17.camel@gandalf.stny.rr.com> <CA+55aFyVb5FE1t5zj7WJR3c=3PnCjwNd=UgC5eFdn5eV5PsEZw@mail.gmail.com>
In-Reply-To: <CA+55aFyVb5FE1t5zj7WJR3c=3PnCjwNd=UgC5eFdn5eV5PsEZw@mail.gmail.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2012 08:45 PM, Linus Torvalds wrote:
> 
> Btw, it might be lovely to consider the concept of "Kconfig variables
> set by shell-scripts".
> 
> We currently have a metric sh*t-ton of Makefile magic for testing
> various things like this, and integrating it into Kconfig might be a
> good idea. That way you would be able to use the Kconfig logic on
> these things.
> 
> Kconfig already has the "option env=XYZ" syntax for importing values
> from the environment variables. Extending it to some kind of "option
> shell=xyz" would allow for more complex interactions like this
> (imagine testing compiler options and version dependencies in the
> Kconfig files instead of the Makefiles)?
> 

This is a Frequently Requested Feature over on the kbuild list... and it
almost certainly would speed up the build given how many times the tests
are currently run.  Furthermore, it would let us base rules on the
support existing, which we currently can't.

	-hpa

