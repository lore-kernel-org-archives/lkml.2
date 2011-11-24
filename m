Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab1KXTT3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 14:19:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42778 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753689Ab1KXTT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 14:19:29 -0500
Date: Thu, 24 Nov 2011 19:19:26 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jassi Brar <jassisinghbrar@gmail.com>, Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: samsung: drop unknown Kconfig symbol
Message-ID: <20111124191925.GC3395@opensource.wolfsonmicro.com>
References: <1322155037.25125.61.camel@x61.thuisdomein>
 <20111124172216.GR8470@opensource.wolfsonmicro.com>
 <1322161754.25125.72.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322161754.25125.72.camel@x61.thuisdomein>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 08:09:14PM +0100, Paul Bolle wrote:

> - Kconfig"), both dated May 14, 2007. So I'm touching code here that has
> been unbuildable (in the mainline tree) for over four years. Isn't that
> in itself sufficient to drop this code (and the incomplete kbuild stuff
> supporting it)?

No, not really.  None of the OpenMoko code (including GTA02) has ever
been usable in mainline as there's a reasonable patch stack for it out
of tree and the more of their code is in mainline the more likely it is
that that situation will improve.  The cost of extra platforms is really
very low and people actually send me patches for the OpenMoko devices
from time to time (much more frequently than for most other boards) so
at least someone cares.

> > I'd suggest discussing this with the OpenMoko guys if you want to do it.

> Who would that be?

Google tells me http://www.openmoko.org is a good start - you might want
to ask on the openmoko-kernel list.
