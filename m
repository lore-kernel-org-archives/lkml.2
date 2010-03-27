Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab0C0OSp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 10:18:45 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59424 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323Ab0C0OSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 10:18:44 -0400
Date: Sat, 27 Mar 2010 15:18:40 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Jan Beulich <JBeulich@novell.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vesafb: use platform_driver_probe() instead of
	platform_driver_register()
Message-ID: <20100327141840.GA15267@pengutronix.de>
References: <4BACF371020000780003738A@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4BACF371020000780003738A@vpn.id2.novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jan,

On Fri, Mar 26, 2010 at 04:48:33PM +0000, Jan Beulich wrote:
> Commit c2e13037e6794bd0d9de3f9ecabf5615f15c160b introduced a huge
> amount of section mismatch warnings in vesafb code. Rather than
> converting all of the annotations, do the obvious and revert the
> __init -> __devinit change, and use the recommended (in that patch)
> alternative to calling platform_driver_register(): vesafb depends on
> information obtained from by kernel at boot time, cannot be a module,
> and no post-boot devices can ever show up.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
Looks good, Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
