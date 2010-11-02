Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab0KBNLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 09:11:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37913 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751899Ab0KBNLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 09:11:41 -0400
Date: Tue, 2 Nov 2010 09:11:47 -0400
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
Message-ID: <20101102131146.GA21476@opensource.wolfsonmicro.com>
References: <1288656853-4625-1-git-send-email-felipe.contreras@gmail.com>
 <1288656853-4625-3-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288656853-4625-3-git-send-email-felipe.contreras@gmail.com>
X-Cookie: Never give an inch!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 02, 2010 at 02:14:13AM +0200, Felipe Contreras wrote:

>  config REGULATOR_TWL4030
>  	bool "TI TWL4030/TWL5030/TWL6030/TPS695x0 PMIC"
>  	depends on TWL4030_CORE
> +	default y
>  	help
>  	  This driver supports the voltage regulators provided by
>  	  this family of companion chips.

This default is not suitable for non-OMAP platforms, it should be
conditional on OMAP or something if we're going to do this (though
generally we handle this with defconfigs rather than in Kconfig).
