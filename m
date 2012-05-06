Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab2EFT6p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 15:58:45 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34351 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab2EFT6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 15:58:44 -0400
Date: Sun, 6 May 2012 20:58:40 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] broken TASK_SIZE for ia32_aout
Message-ID: <20120506195840.GX6871@ZenIV.linux.org.uk>
References: <20120506162000.GT6871@ZenIV.linux.org.uk>
 <CA+55aFzj3Ocjpnw3WdmKjp3oELwmXt=Zs2=fZuYy0TUyF4nXiA@mail.gmail.com>
 <20120506175451.GU6871@ZenIV.linux.org.uk>
 <4FA6BBD9.3040308@zytor.com>
 <20120506184641.GW6871@ZenIV.linux.org.uk>
 <b73ca203-c9d8-4ca3-b680-d00499f284cd@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b73ca203-c9d8-4ca3-b680-d00499f284cd@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2012 at 11:48:15AM -0700, H. Peter Anvin wrote:
> Al Viro <viro@ZenIV.linux.org.uk> wrote:
> >Umm...  Let me restate that question: is there ever a case when it
> >would
> >_not_ be a syscall property?  I.e. when both 64bit and 32bit syscalls
> >are
> >possible for a given process *and* callers of is_compat_task() care
> >about
> >the kind of process and not the kind of syscall?
> >
> >Is e.g. sparc behaviour ("what kind of process it is, regardless of
> >whether
> >we are issuing a 32bit or a 64bit syscall") correct?
> >
> >Sure, on a platform where the possible kind of syscall is a function of
> >process' personality, a thread property can be a used to tell which
> >kind of syscall we are in.

> I would argue Sparc is not correct here but I am not a Sparc expert.

Dave?
