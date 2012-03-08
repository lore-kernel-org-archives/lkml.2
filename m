Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab2CHVFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 16:05:44 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62248 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab2CHVFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 16:05:43 -0500
Date: Thu, 8 Mar 2012 13:05:37 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, "Eric W. Biederman" <ebiederm@xmission.com>,
        Jiri Slaby <jirislaby@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH] sysfs: Optionally count subdirectories to support buggy
 applications
Message-ID: <20120308210537.GA32436@kroah.com>
References: <4F27C6EB.2070305@suse.cz>
 <m14nvc82jo.fsf@fess.ebiederm.org>
 <CA+55aFwZNdoAA9iPMiEp8-+ndgV+CtSZO4neSh_L+gd77k7-vg@mail.gmail.com>
 <m1wr87ywex.fsf@fess.ebiederm.org>
 <m1ehueyz20.fsf_-_@fess.ebiederm.org>
 <CA+55aFyNQnXrL7fWhBt4LYBuoHD_x+j=Af-N=ueFMBkymy9Rnw@mail.gmail.com>
 <CA+55aFzZX544ZDN9vN3jWMWZ=_9ZtpZ9cR6gNEzUnx9RCqR5LQ@mail.gmail.com>
 <4F54BFEC.6000206@suse.cz>
 <20120305160953.GA3870@kroah.com>
 <CA+55aFy1PXiNkXw08tDM7G9AO0_92xm2mEFF961-4Wpizo+6KQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFy1PXiNkXw08tDM7G9AO0_92xm2mEFF961-4Wpizo+6KQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 08:47:27AM -0800, Linus Torvalds wrote:
> On Mon, Mar 5, 2012 at 8:09 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > I don't remember.  I thought there was a proposed patch for this issue
> > from Eric, but I don't see it in my queue anywhere.
> 
> That patch was an abortion. Adding a config option for behavior like
> this is totally bogus, and the only reason for that config option was
> that sysfs did silly things.
> 
> It's only in -next, though, I was assuming that the whole "Kill nlink
> counting" commit never makes it to me. Because I won't take it.
> 
> I outlined how the counting could easily be done without actually
> having to maintain an explicit count in the sysfs.
> 
> Or we should just keep doing the counting.

Ok, I've now reverted this patch in my tree.

greg k-h
