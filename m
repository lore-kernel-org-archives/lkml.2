Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384Ab2ICMtw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 08:49:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45099 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585Ab2ICMtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 08:49:50 -0400
Date: Mon, 3 Sep 2012 14:49:42 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] hid: Remove "default m" from HID_LOGITECH_DJ
In-Reply-To: <20120903044351.GA1590@leaf>
Message-ID: <alpine.LNX.2.00.1209031449140.20709@pobox.suse.cz>
References: <20120903044351.GA1590@leaf>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Sep 2012, Josh Triplett wrote:

> HID_LOGITECH_DJ uses "default m", which enables it in default kernel
> builds.  Since this module just enables extra, non-critical
> functionality for one particular piece of hardware (specifically,
> differentiating multiple wireless keyboards and mice as separate input
> devices rather than treating them as one device), and the hardware works
> just fine with the default USB HID support, drop the "default m".
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> ---
>  drivers/hid/Kconfig |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index fbf4950..d004528 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -307,7 +307,6 @@ config HID_LOGITECH
>  config HID_LOGITECH_DJ
>  	tristate "Logitech Unifying receivers full support"
>  	depends on HID_LOGITECH
> -	default m
>  	---help---
>  	Say Y if you want support for Logitech Unifying receivers and devices.
>  	Unifying receivers are capable of pairing up to 6 Logitech compliant

That was an overlook on my side when merging the driver. Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
