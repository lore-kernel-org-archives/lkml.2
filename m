Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab2BURwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 12:52:42 -0500
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:56561 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751942Ab2BURwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 12:52:41 -0500
Message-ID: <1329846755.20666.4.camel@odin>
Subject: Re: [PATCH v3 0/3] MFD: twl6040: Conversion to i2c driver
From: Liam Girdwood <lrg@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dmitry Torokhov <dtor@mail.ru>,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org
Date: Tue, 21 Feb 2012 17:52:35 +0000
In-Reply-To: <20120221110533.GT5387@sortiz-mobl>
References: <1328868018-24668-1-git-send-email-peter.ujfalusi@ti.com>
	 <20120220194736.GN5387@sortiz-mobl> <4F4372E3.4050408@ti.com>
	 <20120221110533.GT5387@sortiz-mobl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-21 at 12:05 +0100, Samuel Ortiz wrote:
> Hi Peter,
> 
> On Tue, Feb 21, 2012 at 12:33:07PM +0200, Peter Ujfalusi wrote:
> > > I'm not sure hwo we could handle that properly. Either by letting Tony
> > > carrying this patchset, or by sending me the panda patch that adds those
> > > structures. As you prefer.
> > 
> > If Liam would take this series that would be probably the way forward.
> > If he does not have objections.
> > Liam: I can create a branch for you to pull from as soon as all other
> > patch receives the needed acks...
> > 
> > Samuel: if Liam agrees is it possible for you to drop the twl6040
> > related patches from your for-next branch?
> That would make sense to me, yes.
> Liam, if you're ok with taking it, please add my:
> 
> Acked-by: Samuel Ortiz <sameo@linux.intel.com>
> 

Ok, sounds fine by me. Tony is this fine wrt the OMAP board file
updates ?

Thanks

Liam


