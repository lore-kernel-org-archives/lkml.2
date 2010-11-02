Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab0KBUev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 16:34:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58685 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752341Ab0KBUeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 16:34:46 -0400
Date: Tue, 2 Nov 2010 16:34:53 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-usb <linux-usb@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>, Felipe Balbi <balbi@ti.com>,
        Greg KH <greg@kroah.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Hao Wu <hao.wu@intel.com>,
        Alan Cox <alan@linux.intel.com>, Mike Rapoport <mike@compulab.co.il>
Subject: Re: [PATCH v3 2/2] drivers: cleanup Kconfig stuff
Message-ID: <20101102203452.GB32103@opensource.wolfsonmicro.com>
References: <1288656853-4625-1-git-send-email-felipe.contreras@gmail.com>
 <1288656853-4625-3-git-send-email-felipe.contreras@gmail.com>
 <20101102131146.GA21476@opensource.wolfsonmicro.com>
 <AANLkTim6E+e=D88C8g+YDVwS1D5JPeXvVRw-JVoVxh2i@mail.gmail.com>
 <20101102141208.GU31158@pengutronix.de>
 <AANLkTikwGBij05h1GgW0dpvcJedmcOQ1HWCaxaBdhZta@mail.gmail.com>
 <20101102143949.GH21476@opensource.wolfsonmicro.com>
 <AANLkTik6G25x3t9W01e_LRNVRv99CbWY3GFU93mz1wEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik6G25x3t9W01e_LRNVRv99CbWY3GFU93mz1wEg@mail.gmail.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 02, 2010 at 09:46:47PM +0200, Felipe Contreras wrote:
> On Tue, Nov 2, 2010 at 4:39 PM, Mark Brown

> > It did originally but that dependency was removed to allow build
> > coverage for non-OMAP users.

> I'm not sure removing that dependency is worth it. There's probably a
> lot of code in the kernel that can be built without meeting the
> specified dependencies. Maybe there should be a way to differentiate
> soft from hard dependencies for this particular use-case. But I guess
> for now the lack of dependency should be ok.

It's really useful for subsystem maintainers - it means you can do
changes over the subsystem without having to have a build lots and lots
of different configs per chip to make sure everything still at least
compiles.
