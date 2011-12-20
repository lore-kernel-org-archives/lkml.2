Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab1LTCNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 21:13:37 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:16896 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752253Ab1LTCNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 21:13:34 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/5NgMooJ7qiZM3k9w0yVrZ
Date: Mon, 19 Dec 2011 18:13:31 -0800
From: Tony Lindgren <tony@atomide.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2 2/7] ARM: OMAP1: ams-delta: convert latches to
 basic_mmio_gpio
Message-ID: <20111220021331.GB6464@atomide.com>
References: <cover.1324331816.git.jkrzyszt@tis.icnet.pl>
 <201112200159.36558.jkrzyszt@tis.icnet.pl>
 <20111220010446.GA6464@atomide.com>
 <201112200218.03283.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112200218.03283.jkrzyszt@tis.icnet.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [111219 16:46]:
> On Tuesday 20 of December 2011 at 02:04:46, Tony Lindgren wrote:
> > * Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [111219 16:28]:
> > > On Tuesday 20 of December 2011 at 01:06:00, Tony Lindgren wrote:
> > > > 
> > > > This part especially looks like it really should be just a regular
> > > > device driver under drivers/ somewhere. 
> > > 
> > > I really don't understand what kind of a driver you might mean here.
> > > 
> > > The latch_gpios[] table is initially filled with all latch1 and latch2 
> > > GPIO pins in order to register and initialize them from the board file 
> > > until they are handled by respective existing device drivers (leds, 
> > > nand, lcd, serio, serial8250, asoc) instead of those drivers accessing 
> > > the latches with those old ams_delta_latch[12]_write() functions. That 
> > > table will get almost empty after the transision process is completed, 
> > > holding only pins not used by any drivers / connected to unsued devices, 
> > > in order to initialize them from the board file for power saving 
> > > purposes. A separate driver for the purpose of initializing a few GPIO 
> > > pins seems an overkill.
> > 
> > OK maybe update the comments a bit to describe how that table will
> > mostly disappear? It's not obvious from glancing over this patch
> > series :)
> 
> To be sure, do you mean in-line comments? Or the changelog message?

Just the changelog.

Tony
