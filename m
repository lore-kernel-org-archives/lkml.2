Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639Ab2BUSod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 13:44:33 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:29634 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab2BUSob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 13:44:31 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/W++PtqD+CVg77RPaJmLTU
Date: Tue, 21 Feb 2012 10:44:27 -0800
From: Tony Lindgren <tony@atomide.com>
To: Liam Girdwood <lrg@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dmitry Torokhov <dtor@mail.ru>,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 0/3] MFD: twl6040: Conversion to i2c driver
Message-ID: <20120221184427.GQ18185@atomide.com>
References: <1328868018-24668-1-git-send-email-peter.ujfalusi@ti.com>
 <20120220194736.GN5387@sortiz-mobl>
 <4F4372E3.4050408@ti.com>
 <20120221110533.GT5387@sortiz-mobl>
 <1329846755.20666.4.camel@odin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329846755.20666.4.camel@odin>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Liam Girdwood <lrg@ti.com> [120221 09:21]:
> On Tue, 2012-02-21 at 12:05 +0100, Samuel Ortiz wrote:
> > Hi Peter,
> > 
> > On Tue, Feb 21, 2012 at 12:33:07PM +0200, Peter Ujfalusi wrote:
> > > > I'm not sure hwo we could handle that properly. Either by letting Tony
> > > > carrying this patchset, or by sending me the panda patch that adds those
> > > > structures. As you prefer.
> > > 
> > > If Liam would take this series that would be probably the way forward.
> > > If he does not have objections.
> > > Liam: I can create a branch for you to pull from as soon as all other
> > > patch receives the needed acks...
> > > 
> > > Samuel: if Liam agrees is it possible for you to drop the twl6040
> > > related patches from your for-next branch?
> > That would make sense to me, yes.
> > Liam, if you're ok with taking it, please add my:
> > 
> > Acked-by: Samuel Ortiz <sameo@linux.intel.com>
> > 
> 
> Ok, sounds fine by me. Tony is this fine wrt the OMAP board file
> updates ?

Yeah looks OK to me, acked that patch. Let me know if there are
others I should look.

Thanks,

Tony
