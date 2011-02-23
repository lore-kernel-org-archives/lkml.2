Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab1BWWXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 17:23:48 -0500
Received: from kroah.org ([198.145.64.141]:36033 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756100Ab1BWWXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 17:23:47 -0500
Date: Wed, 23 Feb 2011 14:05:33 -0800
From: Greg KH <greg@kroah.com>
To: Stefan Weil <weil@mail.berlios.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Brett Rudley <brudley@broadcom.com>,
        Henry Ptasinski <henryp@broadcom.com>, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: brcm80211: Fix memory leak after kmalloc failure
Message-ID: <20110223220533.GA23425@kroah.com>
References: <1298158151-22903-1-git-send-email-weil@mail.berlios.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298158151-22903-1-git-send-email-weil@mail.berlios.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 20, 2011 at 12:29:11AM +0100, Stefan Weil wrote:
> This error was spotted by cppcheck:
> 
> drivers/staging/brcm80211/phy/wlc_phy_lcn.c:4053: error: Memory leak: ptr
> 
> Cc: Brett Rudley <brudley@broadcom.com>
> Cc: Henry Ptasinski <henryp@broadcom.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: devel@driverdev.osuosl.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Stefan Weil <weil@mail.berlios.de>
> ---
>  drivers/staging/brcm80211/phy/wlc_phy_lcn.c |    1 +

What tree did you make this against?  This file isn't in the linux-next
tree anymore.

thanks,

greg k-h
