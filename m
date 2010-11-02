Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab0KBJPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 05:15:55 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44184 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab0KBJPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 05:15:49 -0400
Date: Tue, 2 Nov 2010 10:15:45 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: linux-kernel@vger.kernel.org, David Vrabel <dvrabel@arcom.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH 1/7] [AVR32] don't check platform_get_irq's return
	value against zero
Message-ID: <20101102091545.GQ31158@pengutronix.de>
References: <1260979809-24811-1-git-send-email-u.kleine-koenig@pengutronix.de> <20101019064543.GA23839@pengutronix.de> <1288605483.2843.71.camel@hcegtvedt>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1288605483.2843.71.camel@hcegtvedt>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Hans-Christian,

On Mon, Nov 01, 2010 at 10:58:03AM +0100, Hans-Christian Egtvedt wrote:
> On Tue, 2010-10-19 at 08:45 +0200, Uwe Kleine-König wrote: 
> > On Wed, Dec 16, 2009 at 05:10:03PM +0100, Uwe Kleine-König wrote:
> > > platform_get_irq returns -ENXIO on failure, so !int_irq was probably
> > > always true.  Better use (int)int_irq <= 0.  Note that a return value of
> > > zero is still handled as error even though this could mean irq0.
> 
> Indeed, but external interrupts are numbered after the internal
> interrupt lines, so in practice this does not happen. At least for now
> with the AP700X series.
> 
> > > This is a followup to 305b3228f9ff4d59f49e6d34a7034d44ee8ce2f0 that
> > > changed the return value of platform_get_irq from 0 to -ENXIO on error.
> 
> Thanks for this fix.
> 
> > > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > > Cc: David Vrabel <dvrabel@arcom.com>
> > > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > > Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
> 
> Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
I thought this to go via the avr32 tree.  You "only" acked, so what tree
do you consider here?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
