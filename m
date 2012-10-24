Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750934Ab2JXENE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 00:13:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55021 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab2JXEND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 00:13:03 -0400
Date: Tue, 23 Oct 2012 21:13:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Anmol Sarma <unmole.in@gmail.com>
Cc: devel@driverdev.osuosl.org, swetland@google.com, arve@android.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: android: binder: Fixed multi-line strings
Message-ID: <20121024041335.GA25336@kroah.com>
References: <n>
 <1349722863-18835-1-git-send-email-unmole.in@gmail.com>
 <1349738114.15802.27.camel@joe-AO722>
 <20121022200212.GA18168@kroah.com>
 <20121023094335.GA13929@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121023094335.GA13929@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 03:13:38PM +0530, Anmol Sarma wrote:
> >From 949ecac6fcd58ffa6d02f6761058dbcfb1c2ba42 Mon Sep 17 00:00:00 2001
> From: Anmol Sarma <unmole.in@gmail.com>
> Date: Tue, 23 Oct 2012 13:47:14 +0530
> Subject: [PATCH] Staging: android: binder: Strings cleanup
> 
> Changed all user visible multi-line stings to single line.

No you didn't:

> @@ -420,12 +422,12 @@ static void binder_set_nice(long nice)
>  	}
>  	min_nice = 20 - current->signal->rlim[RLIMIT_NICE].rlim_cur;
>  	binder_debug(BINDER_DEBUG_PRIORITY_CAP,
> -		     "binder: %d: nice value %ld not allowed use "
> +		     "%d: nice value %ld not allowed use "
>  		     "%ld instead\n", current->pid, nice, min_nice);

That's a multi-line string :(

And you sent 2 copies of this patch, why?

Care to try again?

greg k-h
