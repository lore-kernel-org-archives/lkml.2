Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab0EQXeB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 19:34:01 -0400
Received: from kroah.org ([198.145.64.141]:49319 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162Ab0EQXd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 19:33:59 -0400
Date: Mon, 17 May 2010 16:31:51 -0700
From: Greg KH <greg@kroah.com>
To: Julia Lawall <julia@diku.dk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 28/37] drivers/staging: Use kmemdup
Message-ID: <20100517233151.GB14911@kroah.com>
References: <Pine.LNX.4.64.1005152321190.21345@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1005152321190.21345@ask.diku.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 15, 2010 at 11:21:43PM +0200, Julia Lawall wrote:
>  drivers/staging/cx25821/cx25821-audio-upstream.c        |   11 ++++-------
>  drivers/staging/cx25821/cx25821-video-upstream-ch2.c    |   12 ++++--------
>  drivers/staging/cx25821/cx25821-video-upstream.c        |   10 ++++------
>  drivers/staging/go7007/go7007-driver.c                  |    3 +--

I took this patch, with the exception of the above chunks.  Those need
to go through the v4l tree.

thanks,

greg k-h
