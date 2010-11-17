Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934071Ab0KQLF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 06:05:56 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:33088 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933229Ab0KQLFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 06:05:46 -0500
Date: Wed, 17 Nov 2010 12:05:16 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Eric Cooper <ecc@cmu.edu>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH] add netdev led trigger
Message-ID: <20101117105925.GC1574@ucw.cz>
References: <1289768305-1224-1-git-send-email-ecc@cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289768305-1224-1-git-send-email-ecc@cmu.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Add a netdev LED trigger for all Blinkenlights lovers...
> Originally taken from https://dev.openwrt.org/ticket/2776
> Slightly updated for 2.6.24 by Mickey Lauer <mickey@openmoko.org>
> and for 2.6.36 by Eric Cooper <ecc@cmu.edu>

Nice!

> +/*
> + * Configurable sysfs attributes:
> + *
> + * device_name - network device name to monitor
> + *
> + * interval - duration of LED blink, in milliseconds

This needs to go to Doc/ somewhere.

> + * mode - either "none" (LED is off) or a space separated list
> + * of one or more of:
> + *   link: LED's normal state reflects whether the link is up (has carrier)
> + *         or not
> + *   tx:   LED blinks on transmitted data
> + *   rx:   LED blinks on receive data
> + *
> + * Some suggestions:
> + *
> + *  Simple link status LED:
> + *  $ echo netdev >someled/trigger
> + *  $ echo eth0 >someled/device_name
> + *  $ echo link >someled/mode
> + *
> + *  Ethernet-style link/activity LED:
> + *  $ echo netdev >someled/trigger
> + *  $ echo eth0 >someled/device_name
> + *  $ echo "link tx rx" >someled/mode

One value per file?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
