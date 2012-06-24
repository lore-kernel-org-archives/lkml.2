Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab2FXF1Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 01:27:24 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61543 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab2FXF1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 01:27:23 -0400
Date: Sat, 23 Jun 2012 22:27:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chad Williamson <chad@dahc.us>
Cc: marek.belisko@gmail.com, devel@driverdev.osuosl.org,
        linux@rainbow-software.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: ft1000: checkpatch.pl cleanup of ft1000_usb.h
Message-ID: <20120624052717.GA10105@kroah.com>
References: <1340509950-4903-1-git-send-email-chad@dahc.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340509950-4903-1-git-send-email-chad@dahc.us>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2012 at 10:52:30PM -0500, Chad Williamson wrote:
> Fix numerous checkpatch.pl errors and warnings and other minor
> coding style issues.
> 
> Signed-off-by: Chad Williamson <chad@dahc.us>
> ---
>  drivers/staging/ft1000/ft1000-usb/ft1000_usb.h |  193 +++++++++++++-----------
>  1 files changed, 102 insertions(+), 91 deletions(-)

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

  Your patch did many different things all at once, making it difficult
  to review.  All Linux kernel patches need to only do one thing at a
  time.  If you need to do multiple things (such as clean up all coding
  style issues in a file/driver), do it in a sequence of patches, each
  one doing only one thing.  This will make it easier to review the
  patches to ensure that they are correct, and to help alleviate any
  merge issues that larger patches can cause.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
