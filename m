Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab2KSC3P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 21:29:15 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12402 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab2KSC3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 21:29:13 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sun, 18 Nov 2012 18:29:04 -0800
From: Alex Courbot <acourbot@nvidia.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: Stephen Warren <swarren@nvidia.com>,
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
Date: Mon, 19 Nov 2012 11:29:05 +0900
Message-ID: <8058793.mIXgB85Mso@percival>
Organization: NVIDIA
User-Agent: KMail/4.9.3 (Linux/3.6.6-1-ARCH; KDE/4.9.3; x86_64; ; )
In-Reply-To: <20121117113849.GA5228@lizard>
References: <1353149747-31871-1-git-send-email-acourbot@nvidia.com> <1353149747-31871-2-git-send-email-acourbot@nvidia.com> <20121117113849.GA5228@lizard>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 November 2012 19:38:50 Anton Vorontsov wrote:
> > +++ b/drivers/power/power_seq/Kconfig
> > @@ -0,0 +1,2 @@
> > +config POWER_SEQ
> > +	tristate
> 
> This really needs a proper Kconfig description and a help text, shortly
> describing the purpose of the subsystem.

Does it? The current state makes power seqs automatically selected by drivers 
that need it, and they do not appear in the configuration menu. If we add a 
description they will then become a visible item, so the logic would be to 
make it user-selectable.

If that approach is preferred, I will also have to change pwm-backlight so 
that it compiles without power sequences. Not that I mind, but I liked the 
idea of not adding yet-another-option to the config menu.

Fixed the code according to all your other comments, thanks!

Alex.

