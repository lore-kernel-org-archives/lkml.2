Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab1KYM4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 07:56:42 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45510 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752788Ab1KYM4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 07:56:41 -0500
Date: Fri, 25 Nov 2011 12:56:39 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jassi Brar <jassisinghbrar@gmail.com>, Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: samsung: drop unknown Kconfig symbol
Message-ID: <20111125125638.GC5315@opensource.wolfsonmicro.com>
References: <1322155037.25125.61.camel@x61.thuisdomein>
 <20111124172216.GR8470@opensource.wolfsonmicro.com>
 <1322161754.25125.72.camel@x61.thuisdomein>
 <20111124191925.GC3395@opensource.wolfsonmicro.com>
 <1322164748.25125.88.camel@x61.thuisdomein>
 <20111124222212.GA21244@opensource.wolfsonmicro.com>
 <1322214066.25125.124.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322214066.25125.124.camel@x61.thuisdomein>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 25, 2011 at 10:41:06AM +0100, Paul Bolle wrote:
> On Thu, 2011-11-24 at 22:22 +0000, Mark Brown wrote:
> > > But - repeating my message - none of those patches made the code in the
> > > mainline tree buildable.

> > Which is a problem because...

> Because in mainline there's code that can't be built and can't be run.

Which is a problem because...

> > (and note that you mean "selectable in
> > Kconfig" here).

> The Kconfig files in mainline don't define a symbol MACH_NEO1973_GTA01.

Yes, that would be an example fo the sort of thing that would make it
impossible to select in Kconfig.

> My claim is just that code that has been unbuildable in the mainline
> tree for over four years can be removed. But, as I said in a previous
> message, I don't have any stake in the GTA01 code. I don't mind
> revisiting all this at (say) the end of the v3.3 merge period.

No.  What I'm telling you is not to revisit this, this is not a helpful
change.
