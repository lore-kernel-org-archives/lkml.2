Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab1BNTO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 14:14:28 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:65511 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab1BNTOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 14:14:25 -0500
Date: Mon, 14 Feb 2011 12:14:20 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Peter Tyser <ptyser@xes-inc.com>
Cc: linux-kernel@vger.kernel.org, Alek Du <alek.du@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/3] gpiolib: Add ability to get GPIO pin direction
Message-ID: <20110214191420.GB30647@angua.secretlab.ca>
References: <1294343654-20354-1-git-send-email-ptyser@xes-inc.com>
 <1297698493.965.5475.camel@petert>
 <AANLkTins1TanjbbwVJixmLcO9Gs-z7jryN8Hs0o_EWNK@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTins1TanjbbwVJixmLcO9Gs-z7jryN8Hs0o_EWNK@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 09:02:02AM -0700, Grant Likely wrote:
> On Mon, Feb 14, 2011 at 8:48 AM, Peter Tyser <ptyser@xes-inc.com> wrote:
> > On Thu, 2011-01-06 at 13:54 -0600, Peter Tyser wrote:
> >> Add a new get_direction() function to the gpio_chip structure.  This is
> >> useful so that the direction of a pin can be determined when its
> >> exported.  Previously, the direction defaulted to 'in' regardless of the
> >> actual configuration of the GPIO pin which resulted in the 'direction'
> >> sysfs file often being incorrect.
> >>
> >> If a GPIO driver implements get_direction(), it is called in
> >> gpio_request() to set the initial direction of the pin accurately.
> >
> > I see Grant was just added as a GPIO maintainer, so added him on CC.
> >
> > Anything gating getting these 3 patches being picked up?
> 
> I'll take a look at them later today.

What are the other two patches?  I only see this one.  Can you repost?

g.
