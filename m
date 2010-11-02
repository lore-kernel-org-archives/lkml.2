Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab0KBOfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 10:35:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56255 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753417Ab0KBOfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 10:35:39 -0400
Date: Tue, 2 Nov 2010 10:35:35 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-usb <linux-usb@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>, Felipe Balbi <balbi@ti.com>,
        Greg KH <greg@kroah.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Hao Wu <hao.wu@intel.com>,
        Alan Cox <alan@linux.intel.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Mike Rapoport <mike@compulab.co.il>
Subject: Re: [PATCH v3 2/2] drivers: cleanup Kconfig stuff
Message-ID: <20101102143534.GG21476@opensource.wolfsonmicro.com>
References: <1288656853-4625-1-git-send-email-felipe.contreras@gmail.com>
 <1288656853-4625-3-git-send-email-felipe.contreras@gmail.com>
 <20101102131146.GA21476@opensource.wolfsonmicro.com>
 <AANLkTim6E+e=D88C8g+YDVwS1D5JPeXvVRw-JVoVxh2i@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim6E+e=D88C8g+YDVwS1D5JPeXvVRw-JVoVxh2i@mail.gmail.com>
X-Cookie: Never give an inch!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 02, 2010 at 04:02:18PM +0200, Felipe Contreras wrote:
> On Tue, Nov 2, 2010 at 3:11 PM, Mark Brown

> > This default is not suitable for non-OMAP platforms, it should be
> > conditional on OMAP or something if we're going to do this (though
> > generally we handle this with defconfigs rather than in Kconfig).

> This would only be enabled when TWL4030_CORE is enabled, so non-OMAP
> platforms would not get affected.

TWL4030 can be enabled on other platforms - it's not tied to OMAP
(mostly to enable build coverage).

> I guess you have seen the complaint from Linus regarding ARM relying
> too much on defconfigs. This helps in order to simplify defconfigs,
> and eventually getting rid of them completely.

This solution doesn't seem like it scales so well either, it just shifts
it into the Kconfig files (where everything is all in central files
shared by everyone which has its own problems).  Certainly the goal of
replacing defconfig files with Kconfig seems unattainable.
