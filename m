Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab2A0Skx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:40:53 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56132 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab2A0SkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:40:12 -0500
Date: Fri, 27 Jan 2012 22:40:05 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [RFC c/r 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v7
Message-ID: <20120127184005.GH11086@moon>
References: <20120127175342.273260614@openvz.org>
 <20120127175939.795551339@openvz.org>
 <20120127181525.GD11715@one.firstfloor.org>
 <20120127182403.GG11086@moon>
 <20120127183155.GE11715@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120127183155.GE11715@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 07:31:55PM +0100, Andi Kleen wrote:
> On Fri, Jan 27, 2012 at 10:24:03PM +0400, Cyrill Gorcunov wrote:
> > Sure, I'll try to (btw, where I should send it to? And in which
> > format novadays mans are written? In plain old troff or some
> > human readable asciidocs?) And... should I post man page
> > on LKML as well?
> 
> Manpages are written in troff with -man and you would add the ASCII output
> of the manpage to the commit log and send the troff source at some
> point to linux-man.
>

OK, I see, thanks.

> The basic problem is if this interface is at the right level of abstraction.
> I have some doubts on that. It seems like a long term maintenance nightmare to 
> me. It may be better to put the loop that would call this into the kernel.
> 

Hmm, ie selftest right in kenel?

> > 
> > Hmm.. Andi, I seem not following. And?
> 
> It just doesn't seem like a very useful thing to compare.

I see.

	Cyrill
