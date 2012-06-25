Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553Ab2FYRRW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 13:17:22 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54353 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab2FYRRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 13:17:20 -0400
Date: Mon, 25 Jun 2012 10:17:15 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sherwin Soltani <sherwin@wybc.com>
Cc: swetland@google.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: staging: android: fix binder.c printk macros
Message-ID: <20120625171715.GA29309@kroah.com>
References: <1340431781-2809-1-git-send-email-sherwin@wybc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340431781-2809-1-git-send-email-sherwin@wybc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2012 at 02:09:41AM -0400, Sherwin Soltani wrote:
> Changed to pr_warn, pr_err, and pr_info macros and reformatted some
> lines to bring them under the 80 column limit in the binder.c code.
> 
> Signed-off-by: Sherwin Soltani <sherwin@wybc.com>
> ---
>  drivers/staging/android/binder.c |   74 ++++++++++++++++++++------------------
>  1 file changed, 40 insertions(+), 34 deletions(-)

Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

---   Your patch did many different things all at once, making it
      difficult to review.  All Linux kernel patches need to only do one
      thing at a time.  If you need to do multiple things (such as clean
      up all coding style issues in a file/driver), do it in a sequence
      of patches, each one doing only one thing.  This will make it
      easier to review the patches to ensure that they are correct, and
      to help alleviate any merge issues that larger patches can cause.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
