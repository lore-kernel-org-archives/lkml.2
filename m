Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab1BIMov (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 07:44:51 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45892 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab1BIMou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 07:44:50 -0500
Date: Wed, 9 Feb 2011 13:44:46 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        David Vrabel <dvrabel@arcom.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH RESENT#2] [AVR32] don't check platform_get_irq's return
 value against zero
Message-ID: <20110209124446.GR27982@pengutronix.de>
References: <1288690250.32331.41.camel@hcegtvedt>
 <1297247284-31650-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1297254532.2968.11.camel@hcegtvedt>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1297254532.2968.11.camel@hcegtvedt>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 01:28:52PM +0100, Hans-Christian Egtvedt wrote:
> On Wed, 2011-02-09 at 11:28 +0100, Uwe Kleine-König wrote: 
> > platform_get_irq returns -ENXIO on failure, so !int_irq was probably
> > always true.  Better use (int)int_irq <= 0.  Note that a return value of
> > zero is still handled as error even though this could mean irq0.
> > 
> > This is a followup to 305b3228f9ff4d59f49e6d34a7034d44ee8ce2f0 that
> > changed the return value of platform_get_irq from 0 to -ENXIO on error.
> > 
> > Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > ---
> > Hello,
> > 
> > Hans-Christian Egtvedt asked to push this patch via Linus as there is no avr32
> > tree.
> > 
> > @Andrew: do you take it?
> 
> Actually, now I have a tree for AVR32 on git.kernel.org, but I have no
> other updates lined up for 2.6.38. Will you Andrew add it to your
> series, or should I push this one through my git tree?
I don't consider it that critical.  So for me getting it in the avr32
tree now and then getting it merged for .39 would be OK for me.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
