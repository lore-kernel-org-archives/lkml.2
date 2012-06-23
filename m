Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab2FWPIM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 11:08:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34237 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482Ab2FWPIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 11:08:02 -0400
Date: Sat, 23 Jun 2012 08:07:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Peiyong Feng <peiyong.feng.kernel@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Implement uhook(call kernel func from userspace) driver
Message-ID: <20120623150757.GB2515@kroah.com>
References: <CAN_1RdvqJRig8vZW_gcvNVKYNo7ROmEKxAs7qu1N6XE4+Pspjg@mail.gmail.com>
 <20120623040633.GA16278@kroah.com>
 <CAN_1RdtfiWtuqV=vBkagZfmvstket499QdCK3zZrrS8xKTZwPA@mail.gmail.com>
 <20120623044105.GA32663@kroah.com>
 <CAN_1RduD=yh0vjVdb3RwQn9ivxcBEGgJ3aTXuGgj4=FEznYmXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAN_1RduD=yh0vjVdb3RwQn9ivxcBEGgJ3aTXuGgj4=FEznYmXg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2012 at 02:01:59PM +0800, Peiyong Feng wrote:
> 2012/6/23 Greg KH <gregkh@linuxfoundation.org>:
> > On Sat, Jun 23, 2012 at 12:18:29PM +0800, Peiyong Feng wrote:
> >> 2012/6/23 Greg KH <gregkh@linuxfoundation.org>:
> >> > On Sat, Jun 23, 2012 at 11:20:35AM +0800, Peiyong Feng wrote:
> >> >> Hi all,
> >> >>
> >> >> This patch implement the uhook kernel driver. Here are some ideals and
> >> >> explanations:
> >> >>
> >> >> 1. What is uhook
> >> >>
> >> >> uhook(userspace kernel hook) means call kernel function from
> >> >> userspace. That is to say, we can
> >> >>
> >> >> write a function in kernel space and call it in userspace while the
> >> >> kernel Image is running. For example:
> >> >
> >> > That's, um, "interesting", but is of course, nothing we can accept into
> >> > the main kernel tree, as I'm sure you can understand.  Otherwise, you
> >> > just created a few thousand undocumented system calls whose behavior
> >> > changes every release which is not something we can accept.
> >> >
> >> > But it is a great hack, very nicely done.  I'm sure that some people
> >> > will like it for debugging, although I'm not quite sure you got all of
> >>
> >> Well, is there some other tree I can commit the patch?
> >
> > What do you mean by this?
> 
> I mean that although the main line kernel cannot accept this patch, and
> uhook is very useful to play a rule as a debug tool. Is there some where else
> that can hold this tool, and let more people use the uhook?

Not that I know of.  As someone pointed out, use github to host it on
your own if you want, that is probably the best.

greg k-h
