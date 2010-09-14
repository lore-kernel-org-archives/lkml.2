Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab0INXkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 19:40:06 -0400
Received: from kroah.org ([198.145.64.141]:42735 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950Ab0INXkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 19:40:04 -0400
Date: Tue, 14 Sep 2010 16:34:52 -0700
From: Greg KH <greg@kroah.com>
To: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Arnaud Patard <apatard@mandriva.com>
Subject: Re: [patch 1/1] Change my mail address
Message-ID: <20100914233452.GA10770@kroah.com>
References: <20100909121032.713581987@rtp-net.org>
 <20100909121040.781762033@rtp-net.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100909121040.781762033@rtp-net.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 09, 2010 at 02:10:33PM +0200, Arnaud Patard wrote:
> Like other coworkers, I'm about leave Mandriva/Edge-It so I'm changing
> my mail address to use my personal one.
> 
> Signed-off-by: Arnaud Patard <arnaud.patard@rtp-net.org>
> Signed-off-by: Arnaud Patard <apatard@mandriva.com>
> Index: sound-2.6/drivers/staging/xgifb/TODO
> ===================================================================
> --- sound-2.6.orig/drivers/staging/xgifb/TODO	2010-09-08 16:11:56.000000000 +0200
> +++ sound-2.6/drivers/staging/xgifb/TODO	2010-09-08 16:12:08.000000000 +0200
> @@ -12,4 +12,4 @@
>  - get rid of non-linux related stuff
>  
>  Please send patches to:
> -Arnaud Patard <apatard@mandriva.com>
> +Arnaud Patard <arnaud.patard@rtp-net.org>

I can take this part of the patch, but not the "sound/*" part of the
patch.  Mark, care to take that part of the patch, or the whole thing?
If the whole thing, feel free to add:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
to the patch.

thanks,

greg k-h
