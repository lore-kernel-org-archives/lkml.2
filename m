Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab2CHXkw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 18:40:52 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54403 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665Ab2CHXks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 18:40:48 -0500
MIME-Version: 1.0
In-Reply-To: <m1zkbqu46w.fsf@fess.ebiederm.org>
References: <20120130222717.GA6393@kroah.com> <m18vkoirv9.fsf@fess.ebiederm.org>
 <4F27C6EB.2070305@suse.cz> <m14nvc82jo.fsf@fess.ebiederm.org>
 <CA+55aFwZNdoAA9iPMiEp8-+ndgV+CtSZO4neSh_L+gd77k7-vg@mail.gmail.com>
 <m1wr87ywex.fsf@fess.ebiederm.org> <m1ehueyz20.fsf_-_@fess.ebiederm.org>
 <CA+55aFyNQnXrL7fWhBt4LYBuoHD_x+j=Af-N=ueFMBkymy9Rnw@mail.gmail.com>
 <CA+55aFzZX544ZDN9vN3jWMWZ=_9ZtpZ9cR6gNEzUnx9RCqR5LQ@mail.gmail.com>
 <4F54BFEC.6000206@suse.cz> <20120305160953.GA3870@kroah.com>
 <CA+55aFy1PXiNkXw08tDM7G9AO0_92xm2mEFF961-4Wpizo+6KQ@mail.gmail.com> <m1zkbqu46w.fsf@fess.ebiederm.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 8 Mar 2012 15:40:26 -0800
X-Google-Sender-Auth: HW-2zncvHBL-u6NFU_LYDnbGbzE
Message-ID: <CA+55aFwSETK6bz5-q6HMKGqnweTPuR-MA6w-19-Fto13jDU4GA@mail.gmail.com>
Subject: Re: [PATCH] sysfs: Optionally count subdirectories to support buggy applications
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Jiri Slaby <jirislaby@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 8, 2012 at 2:18 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> Keeping compatibility is easy enough that it looks like it is worth
> doing, but maintaining 30+ years of backwards compatibility

Stop right there.

This is *not* about some arbitrary "30-year backwards compatibility".

This is about your patch BREAKING EXISTING BINARIES.

So stop the f*&^ing around already. The patch was shown to be broken,
stop making excuses, and stop blathering.

End of story. Binary compatibility is more important than *any* of
your patches. If you continue to argue anything else or making
excuses, I'm going to ask people to just ignore your patches entirely.

Seriously. Binary compatibility is *so* important that I do not want
to have anything to do with kernel developers who don't understand
that importance. If you continue to pooh-pooh the issue, you only show
yourself to be unreliable.  Don't do it.

Dammit, I'm continually surprised by the *idiots* out there that don't
understand that binary compatibility is one of the absolute top
priorities. The *only* reason for an OS kernel existing in the first
place is to serve user-space. The kernel has no relevance on its own.
Breaking existing binaries - and then not acknowledging how horribly
bad that was - is just about the *worst* offense any kernel developer
can do.

Because that shows that they don't understand what the whole *point*
of the kernel was after all. We're not masturbating around with some
research project.  We never were. Even when Linux was young, the whole
and only point was to make a *usable* system. It's why it's not some
crazy drug-induced microkernel or other random crazy thing.

Really.

                     Linus
