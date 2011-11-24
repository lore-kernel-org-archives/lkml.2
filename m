Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab1KXWWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 17:22:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52996 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751090Ab1KXWWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 17:22:14 -0500
Date: Thu, 24 Nov 2011 22:22:12 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jassi Brar <jassisinghbrar@gmail.com>, Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: samsung: drop unknown Kconfig symbol
Message-ID: <20111124222212.GA21244@opensource.wolfsonmicro.com>
References: <1322155037.25125.61.camel@x61.thuisdomein> <20111124172216.GR8470@opensource.wolfsonmicro.com> <1322161754.25125.72.camel@x61.thuisdomein> <20111124191925.GC3395@opensource.wolfsonmicro.com> <1322164748.25125.88.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322164748.25125.88.camel@x61.thuisdomein>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 08:59:08PM +0100, Paul Bolle wrote:
> On Thu, 2011-11-24 at 19:19 +0000, Mark Brown wrote:

> > The cost of extra platforms is really
> > very low and people actually send me patches for the OpenMoko devices
> > from time to time (much more frequently than for most other boards) so
> > at least someone cares.

> But - repeating my message - none of those patches made the code in the
> mainline tree buildable.

Which is a problem because...  (and note that you mean "selectable in
Kconfig" here).

> I don't have any stake in the GTA01 code. So I don't really mind
> deferring this discussion to (say) the end of the v3.3 merge period.
> But, surely, there must be a point where one can conclude that
> unbuildable code is just that?

No.  Removing this code has negative value.  There is no meaningful cost
in having it in mainline; your patch has been the biggest piece of work
so far other than updates done by people actively working on the
machine.  On the other hand the OpenMoko guys from time to time send
useful patches and report interesting bugs (they sent a patch only last
week in fact) and are definitely a user for the code (which is more than
can be said for most of the legacy boards in mainline).

Please take a step back, think about what value would be brought by
making this change.
