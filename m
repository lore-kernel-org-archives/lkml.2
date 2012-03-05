Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab2CEQru (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:47:50 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:57945 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622Ab2CEQrs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:47:48 -0500
MIME-Version: 1.0
In-Reply-To: <20120305160953.GA3870@kroah.com>
References: <20120130222717.GA6393@kroah.com> <m18vkoirv9.fsf@fess.ebiederm.org>
 <4F27C6EB.2070305@suse.cz> <m14nvc82jo.fsf@fess.ebiederm.org>
 <CA+55aFwZNdoAA9iPMiEp8-+ndgV+CtSZO4neSh_L+gd77k7-vg@mail.gmail.com>
 <m1wr87ywex.fsf@fess.ebiederm.org> <m1ehueyz20.fsf_-_@fess.ebiederm.org>
 <CA+55aFyNQnXrL7fWhBt4LYBuoHD_x+j=Af-N=ueFMBkymy9Rnw@mail.gmail.com>
 <CA+55aFzZX544ZDN9vN3jWMWZ=_9ZtpZ9cR6gNEzUnx9RCqR5LQ@mail.gmail.com>
 <4F54BFEC.6000206@suse.cz> <20120305160953.GA3870@kroah.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 5 Mar 2012 08:47:27 -0800
X-Google-Sender-Auth: 5Gqj7tAx8nLg2ADo4Xk7RvZ3yEI
Message-ID: <CA+55aFy1PXiNkXw08tDM7G9AO0_92xm2mEFF961-4Wpizo+6KQ@mail.gmail.com>
Subject: Re: [PATCH] sysfs: Optionally count subdirectories to support buggy applications
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, "Eric W. Biederman" <ebiederm@xmission.com>,
        Jiri Slaby <jirislaby@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 5, 2012 at 8:09 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> I don't remember.  I thought there was a proposed patch for this issue
> from Eric, but I don't see it in my queue anywhere.

That patch was an abortion. Adding a config option for behavior like
this is totally bogus, and the only reason for that config option was
that sysfs did silly things.

It's only in -next, though, I was assuming that the whole "Kill nlink
counting" commit never makes it to me. Because I won't take it.

I outlined how the counting could easily be done without actually
having to maintain an explicit count in the sysfs.

Or we should just keep doing the counting.

                    Linus
