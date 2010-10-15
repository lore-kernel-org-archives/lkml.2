Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447Ab0JOTsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 15:48:33 -0400
Received: from kroah.org ([198.145.64.141]:44023 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932378Ab0JOTsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 15:48:32 -0400
Date: Fri, 15 Oct 2010 12:40:40 -0700
From: Greg KH <greg@kroah.com>
To: Marek Belisko <marek.belisko@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] staging: ft1000: Remove FT1000_INFO typedef usage.
Message-ID: <20101015194040.GA20880@kroah.com>
References: <1287144784-3359-1-git-send-email-marek.belisko@gmail.com>
 <1287144784-3359-7-git-send-email-marek.belisko@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287144784-3359-7-git-send-email-marek.belisko@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 02:13:04PM +0200, Marek Belisko wrote:
> Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
> ---
>  drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c   |   28 +++++++-------
>  .../staging/ft1000/ft1000-usb/ft1000_download.c    |   16 ++++----
>  drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |   42 ++++++++++----------
>  drivers/staging/ft1000/ft1000-usb/ft1000_proc.c    |   14 +++---
>  drivers/staging/ft1000/ft1000-usb/ft1000_usb.c     |    8 ++--
>  drivers/staging/ft1000/ft1000-usb/ft1000_usb.h     |    6 +-
>  6 files changed, 57 insertions(+), 57 deletions(-)

Something's wrong with this patch.  There was also something wrong with
one of the previous ones as well, but I fixed it up by hand.  It seems
that you forgot to send one of the patches in this series, which caused
this one to throw a lot of rejects.

Care to resync on my tree to see what I haven't applied from you and
resend this one, and anything else I've missed?

thanks,

greg k-h
