Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab1KXT7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 14:59:17 -0500
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:36684 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab1KXT7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 14:59:16 -0500
Message-ID: <1322164748.25125.88.camel@x61.thuisdomein>
Subject: Re: [PATCH] ASoC: samsung: drop unknown Kconfig symbol
From: Paul Bolle <pebolle@tiscali.nl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jassi Brar <jassisinghbrar@gmail.com>, Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Date: Thu, 24 Nov 2011 20:59:08 +0100
In-Reply-To: <20111124191925.GC3395@opensource.wolfsonmicro.com>
References: <1322155037.25125.61.camel@x61.thuisdomein>
	 <20111124172216.GR8470@opensource.wolfsonmicro.com>
	 <1322161754.25125.72.camel@x61.thuisdomein>
	 <20111124191925.GC3395@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-24 at 19:19 +0000, Mark Brown wrote:
> On Thu, Nov 24, 2011 at 08:09:14PM +0100, Paul Bolle wrote:
> > - Kconfig"), both dated May 14, 2007. So I'm touching code here that has
> > been unbuildable (in the mainline tree) for over four years. Isn't that
> > in itself sufficient to drop this code (and the incomplete kbuild stuff
> > supporting it)?
> 
> No, not really.  None of the OpenMoko code (including GTA02) has ever
> been usable in mainline as there's a reasonable patch stack for it out
> of tree and the more of their code is in mainline the more likely it is
> that that situation will improve.

A reasonable out of tree patch stack doesn't make the mainline tree
itself buildable. And it could be that having code in mainline makes it
more likely that this situation will improve. But, when I look at the
current situation of the mainline tree, I just see code that has been
unbuildable for over four years.

> The cost of extra platforms is really
> very low and people actually send me patches for the OpenMoko devices
> from time to time (much more frequently than for most other boards) so
> at least someone cares.

But - repeating my message - none of those patches made the code in the
mainline tree buildable.

I don't have any stake in the GTA01 code. So I don't really mind
deferring this discussion to (say) the end of the v3.3 merge period.
But, surely, there must be a point where one can conclude that
unbuildable code is just that?


Paul Bolle

