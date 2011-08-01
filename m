Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab1HARwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 13:52:42 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:35451 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab1HARwg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 13:52:36 -0400
MIME-Version: 1.0
In-Reply-To: <20110801043207.GE2203@ZenIV.linux.org.uk>
References: <1312066693.22074.50.camel@i7.infradead.org>
	<1312066923.22074.53.camel@i7.infradead.org>
	<CAFLxGvy0QqoySDFwZpygHeXvQ7hG-B7z5iZq8qx3GUkFX8w2RQ@mail.gmail.com>
	<1312151063.18010.25.camel@i7.infradead.org>
	<20110731224834.GC2203@ZenIV.linux.org.uk>
	<20110731225801.GD2203@ZenIV.linux.org.uk>
	<1312153988.18010.39.camel@i7.infradead.org>
	<CAFLxGvyewG70ZgU41Kmu_eOYpjZ0TVXYwYq1AfS1sXONAM6G_w@mail.gmail.com>
	<20110801043207.GE2203@ZenIV.linux.org.uk>
Date: Mon, 1 Aug 2011 19:52:35 +0200
Message-ID: <CAFLxGvwxQ2VeqkDpkiVks35DHxZFvAP5nKUtD7i4Z32291otOg@mail.gmail.com>
Subject: Re: [PATCH 1/5] um: Use __i386__ in ifdef for vsyscall exports, not SUBARCH_i386
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>, Arnaud Lacombe <lacombar@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 1, 2011 at 6:32 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> Anyway, could you take a look at the git tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/um-header.git/,
> branch x86_merge and comment?  It doesn't include stuff from this
> thread (yet); what it does is
>        * further headers cleanups
>        * sys-{i386,x86_64} merged; all[1] x86-specific code taken first
> to arch/um/sys-x86 and then (by final commit) to arch/x86/um.  IMO that's
> the right place for it - target-dependent code is better off not hidden
> from maintainers of the target arch.  When we get other ports to working
> shape, their target-specific parts ought to go into arch/<target>/um.
>        * hopefully saner treatment of sigcontext; should make life easier
> for other ports.
>
> [1] theoretically - in reality we still have more than a few x86-isms in
> "generic" um headers in arch/um/include/asm.
>

Ok, will look at it in the next few days.
"sys-{i386,x86_64} merged" sounds great!

-- 
Thanks,
//richard
