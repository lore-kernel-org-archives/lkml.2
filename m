Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612Ab2FYRY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 13:24:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45866 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab2FYRY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 13:24:27 -0400
Date: Mon, 25 Jun 2012 10:24:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: devel@driverdev.osuosl.org, swetland@google.com,
        Sherwin Soltani <sherwin@wybc.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: staging: android: fix binder.c printk macros
Message-ID: <20120625172423.GA1935@kroah.com>
References: <1340431781-2809-1-git-send-email-sherwin@wybc.com>
 <20120625171715.GA29309@kroah.com>
 <1340644800.3359.1.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340644800.3359.1.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 10:20:00AM -0700, Joe Perches wrote:
> On Mon, 2012-06-25 at 10:17 -0700, Greg KH wrote:
> > On Sat, Jun 23, 2012 at 02:09:41AM -0400, Sherwin Soltani wrote:
> > > Changed to pr_warn, pr_err, and pr_info macros and reformatted some
> > > lines to bring them under the 80 column limit in the binder.c code.
> > > 
> > > Signed-off-by: Sherwin Soltani <sherwin@wybc.com>
> > > ---
> > >  drivers/staging/android/binder.c |   74 ++++++++++++++++++++------------------
> > >  1 file changed, 40 insertions(+), 34 deletions(-)
> > 
> > Hi,
> > 
> > This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
> > a patch that has triggered this response.  He used to manually respond
> > to these common problems, but in order to save his sanity (he kept
> > writing the same thing over and over, yet to different people), I was
> > created.  Hopefully you will not take offence and will fix the problem
> > in your patch and resubmit it so that it can be accepted into the Linux
> > kernel tree.
> 
> > You are receiving this message because of the following common error(s)
> > as indicated below:
> > 
> > ---   Your patch did many different things all at once, making it
> >       difficult to review.
> 
> Your patch-bot needs work.
> 
> Converting printks to pr_<level> is trivial
> and should be done all at once, not piecemeal.

I'm not disagreeing with that, unfortunately this patch also did more
than just pr_<level> conversions, which is why my patch-bot kicked in.

So your patch-bot complaint generator needs work :)

greg k-h
