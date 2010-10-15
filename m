Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465Ab0JOTsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 15:48:42 -0400
Received: from kroah.org ([198.145.64.141]:44026 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932415Ab0JOTsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 15:48:33 -0400
Date: Fri, 15 Oct 2010 12:43:16 -0700
From: Greg KH <greg@kroah.com>
To: Marek Belisko <marek.belisko@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:ft1000: Get rid of using typedef.
Message-ID: <20101015194316.GA32598@kroah.com>
References: <1287127279-14209-1-git-send-email-marek.belisko@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287127279-14209-1-git-send-email-marek.belisko@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 09:21:19AM +0200, Marek Belisko wrote:
> Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
> ---
>  drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c |   26 +++++++++++-----------
>  drivers/staging/ft1000/ft1000-usb/ft1000_hw.c    |    8 +++---
>  drivers/staging/ft1000/ft1000-usb/ft1000_usb.h   |    8 +++---
>  3 files changed, 21 insertions(+), 21 deletions(-)

This one also did not apply.

thanks,

greg k-h
