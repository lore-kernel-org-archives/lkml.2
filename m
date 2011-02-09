Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab1BIM7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 07:59:25 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:9640 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754597Ab1BIM7Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 07:59:24 -0500
Subject: Re: [PATCH RESENT#2] [AVR32] don't check platform_get_irq's return
 value against zero
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        David Vrabel <dvrabel@arcom.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Haavard Skinnemoen <hskinnemoen@atmel.com>
In-Reply-To: <20110209124446.GR27982@pengutronix.de>
References: <1288690250.32331.41.camel@hcegtvedt>
	 <1297247284-31650-1-git-send-email-u.kleine-koenig@pengutronix.de>
	 <1297254532.2968.11.camel@hcegtvedt>
	 <20110209124446.GR27982@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Wed, 09 Feb 2011 13:51:00 +0100
Message-ID: <1297255860.2968.12.camel@hcegtvedt>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 09 Feb 2011 12:51:03.0559 (UTC) FILETIME=[028BE170:01CBC858]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-09 at 13:44 +0100, Uwe Kleine-König wrote: 
> On Wed, Feb 09, 2011 at 01:28:52PM +0100, Hans-Christian Egtvedt wrote:
> > On Wed, 2011-02-09 at 11:28 +0100, Uwe Kleine-König wrote: 
> > > platform_get_irq returns -ENXIO on failure, so !int_irq was probably
> > > always true.  Better use (int)int_irq <= 0.  Note that a return value of
> > > zero is still handled as error even though this could mean irq0.
> > > 
> > > This is a followup to 305b3228f9ff4d59f49e6d34a7034d44ee8ce2f0 that
> > > changed the return value of platform_get_irq from 0 to -ENXIO on error.
> > > 
> > > Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
> > > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > > ---
> > > Hello,
> > > 
> > > Hans-Christian Egtvedt asked to push this patch via Linus as there is no avr32
> > > tree.
> > > 
> > > @Andrew: do you take it?
> > 
> > Actually, now I have a tree for AVR32 on git.kernel.org, but I have no
> > other updates lined up for 2.6.38. Will you Andrew add it to your
> > series, or should I push this one through my git tree?
> I don't consider it that critical.  So for me getting it in the avr32
> tree now and then getting it merged for .39 would be OK for me.

Okay, then I'll schedule it for the next release.

-- 
Hans-Christian Egtvedt

