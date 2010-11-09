Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab0KIX6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 18:58:14 -0500
Received: from kroah.org ([198.145.64.141]:49266 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526Ab0KIX6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 18:58:09 -0500
Date: Tue, 9 Nov 2010 15:57:58 -0800
From: Greg KH <greg@kroah.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: r8712u: Fix sparse message
Message-ID: <20101109235758.GD9001@kroah.com>
References: <4cc9ef57.olkJXiwQEtL/lNA3%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4cc9ef57.olkJXiwQEtL/lNA3%Larry.Finger@lwfinger.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 04:47:03PM -0500, Larry Finger wrote:
> >From b57eb713ef7d36b2fe10ec83a989ba1845e098b6 Mon Sep 17 00:00:00 2001
> From: Larry Finger <Larry.Finger@lwfinger.net>
> Date: Tue, 26 Oct 2010 11:02:25 -0500
> Subject: [PATCH 2/2] staging: r8712u: Fix sparse message
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>  drivers/staging/rtl8712/TODO                  |    1 -
>  drivers/staging/rtl8712/rtl871x_ioctl_linux.c |    1 +
>  drivers/staging/rtl8712/rtl871x_mp_ioctl.c    |    2 --
>  drivers/staging/rtl8712/rtl871x_mp_ioctl.h    |    2 +-
>  4 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/rtl8712/TODO b/drivers/staging/rtl8712/TODO
> index ed22b0b..d8dfe5b 100644
> --- a/drivers/staging/rtl8712/TODO
> +++ b/drivers/staging/rtl8712/TODO
> @@ -3,7 +3,6 @@ TODO:
>  - switch to use LIB80211
>  - switch to use MAC80211
>  - checkpatch.pl fixes - only a few remain
> -- sparse fixes
>  
>  Please send any patches to Greg Kroah-Hartman <greg@kroah.com>,
>  Larry Finger <Larry.Finger@lwfinger.net> and

This part of the patch doesn't apply anymore, which is odd.

Anyway, care to redo it against linux-next and resend it?

thanks,

greg k-h
