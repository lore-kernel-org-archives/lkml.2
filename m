Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab2KSCgG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 21:36:06 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35380 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab2KSCgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 21:36:03 -0500
Date: Sun, 18 Nov 2012 18:32:52 -0800
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mark Zhang <markz@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCHv9 1/3] Runtime Interpreted Power Sequences
Message-ID: <20121119023251.GA2131@lizard>
References: <1353149747-31871-1-git-send-email-acourbot@nvidia.com>
 <1353149747-31871-2-git-send-email-acourbot@nvidia.com>
 <20121117113849.GA5228@lizard>
 <8058793.mIXgB85Mso@percival>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8058793.mIXgB85Mso@percival>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 11:29:05AM +0900, Alex Courbot wrote:
> On Saturday 17 November 2012 19:38:50 Anton Vorontsov wrote:
> > > +++ b/drivers/power/power_seq/Kconfig
> > > @@ -0,0 +1,2 @@
> > > +config POWER_SEQ
> > > +	tristate
> > 
> > This really needs a proper Kconfig description and a help text, shortly
> > describing the purpose of the subsystem.
> 
> Does it? The current state makes power seqs automatically selected by drivers 
> that need it, and they do not appear in the configuration menu. If we add a 
> description they will then become a visible item, so the logic would be to 
> make it user-selectable.

Ah. OK, then yes, there is no need for the short description, but the help
text would a good idea anyway.

Thanks,
Anton.
