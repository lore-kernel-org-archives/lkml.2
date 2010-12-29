Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab0L2QZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 11:25:16 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58489 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab0L2QZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 11:25:14 -0500
Date: Wed, 29 Dec 2010 17:25:12 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: (arm-)global platform device registration functions
Message-ID: <20101229162512.GI14221@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

some time ago I started to dynamically allocate platform_devices for
arm/plat-mxc.  For that purpose I added many functions, see
arch/arm/plat-mxc/include/mach/devices-common.h [1].  Now arm/arch-mxs
want to do the same, so I wonder if it would be sensible to do something
like this more globally (either for arm or better kernel global).

Thoughts?

Best regards
Uwe

[1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=arch/arm/plat-mxc/include/mach/devices-common.h;hb=HEAD

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
