Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab2JPCxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 22:53:55 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:55654 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007Ab2JPCxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 22:53:54 -0400
Date: Mon, 15 Oct 2012 22:53:49 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] include/version.h: Update for kernel 3.7
Message-ID: <20121016025349.GB17446@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
References: <507c837f.D1Nk8uFiYhA4dhxy%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <507c837f.D1Nk8uFiYhA4dhxy%Larry.Finger@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 04:43:27PM -0500, Larry Finger wrote:
> The value for LINUX_VERSION_CODE was not updated for kernel 3.7-rc1.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>  version.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> ---
> 
> Index: linux-2.6/include/linux/version.h
> ===================================================================
> --- linux-2.6.orig/include/linux/version.h
> +++ linux-2.6/include/linux/version.h
> @@ -1,2 +1,2 @@
> -#define LINUX_VERSION_CODE 198144
> +#define LINUX_VERSION_CODE 198400
>  #define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))

This isn't in the Linux git sources; it's a generated file.

     	      	  	       	     	    - Ted
