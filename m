Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab0L2UiK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 15:38:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751018Ab0L2UiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 15:38:08 -0500
Date: Wed, 29 Dec 2010 12:37:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: (arm-)global platform device registration functions
Message-Id: <20101229123740.c39238f8.akpm@linux-foundation.org>
In-Reply-To: <20101229162512.GI14221@pengutronix.de>
References: <20101229162512.GI14221@pengutronix.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Dec 2010 17:25:12 +0100
Uwe Kleine-K__nig <u.kleine-koenig@pengutronix.de> wrote:

> Hello,
> 
> some time ago I started to dynamically allocate platform_devices for
> arm/plat-mxc.  For that purpose I added many functions, see
> arch/arm/plat-mxc/include/mach/devices-common.h [1].  Now arm/arch-mxs
> want to do the same, so I wonder if it would be sensible to do something
> like this more globally (either for arm or better kernel global).
> 

Sounds sensible to me, although I don't really understand what you've
done - didn't platform_device_alloc() already "dynamically allocate
platform_devices"?

If you were to implement this common infrastructure, there may be
already-existing code which could use it.  How would we locate that?

