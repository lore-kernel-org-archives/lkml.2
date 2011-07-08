Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab1GHGrs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 02:47:48 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47217 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab1GHGrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 02:47:45 -0400
Date: Fri, 8 Jul 2011 08:47:42 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Airlie <airlied@linux.ie>
Subject: Re: [089/107] drivers/base/platform.c: dont mark
 platform_device_register_resndata() as __init_or_module
Message-ID: <20110708064742.GM29624@pengutronix.de>
References: <20110708001740.GA14031@kroah.com>
 <20110708001701.406081654@clark.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110708001701.406081654@clark.kroah.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jul 07, 2011 at 05:17:01PM -0700, Greg KH wrote:
> 2.6.39-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> commit bb2b43fefab723f4a0760146e7bed59d41a50e53 upstream.
> 
> This reverts 737a3bb9416ce2a7c7a4 ("Driver core: move platform device
> creation helpers to .init.text (if MODULE=n)").  That patch assumed that
> platform_device_register_resndata() is only ever called from __init code
> but that isn't true in the case ioctl->drm_ioctl->radeon_cp_init().
> 
> Addresses https://bugzilla.kernel.org/show_bug.cgi?id=35192
> 
> Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

> Reported-by: Anthony Basile <blueness@gentoo.org>
> Cc: Greg KH <gregkh@suse.de>
> Cc: David Airlie <airlied@linux.ie>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
You might want to remove one of your sobs.

Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
