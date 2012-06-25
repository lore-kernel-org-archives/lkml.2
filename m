Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601Ab2FYRUD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 13:20:03 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46366 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757511Ab2FYRUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 13:20:01 -0400
Message-ID: <1340644800.3359.1.camel@joe2Laptop>
Subject: Re: [PATCH] drivers: staging: android: fix binder.c printk macros
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Sherwin Soltani <sherwin@wybc.com>, swetland@google.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Mon, 25 Jun 2012 10:20:00 -0700
In-Reply-To: <20120625171715.GA29309@kroah.com>
References: <1340431781-2809-1-git-send-email-sherwin@wybc.com>
	 <20120625171715.GA29309@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-25 at 10:17 -0700, Greg KH wrote:
> On Sat, Jun 23, 2012 at 02:09:41AM -0400, Sherwin Soltani wrote:
> > Changed to pr_warn, pr_err, and pr_info macros and reformatted some
> > lines to bring them under the 80 column limit in the binder.c code.
> > 
> > Signed-off-by: Sherwin Soltani <sherwin@wybc.com>
> > ---
> >  drivers/staging/android/binder.c |   74 ++++++++++++++++++++------------------
> >  1 file changed, 40 insertions(+), 34 deletions(-)
> 
> Hi,
> 
> This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
> a patch that has triggered this response.  He used to manually respond
> to these common problems, but in order to save his sanity (he kept
> writing the same thing over and over, yet to different people), I was
> created.  Hopefully you will not take offence and will fix the problem
> in your patch and resubmit it so that it can be accepted into the Linux
> kernel tree.

> You are receiving this message because of the following common error(s)
> as indicated below:
> 
> ---   Your patch did many different things all at once, making it
>       difficult to review.

Your patch-bot needs work.

Converting printks to pr_<level> is trivial
and should be done all at once, not piecemeal.


