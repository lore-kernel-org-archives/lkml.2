Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab2H1Qsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 12:48:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44458 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751982Ab2H1Qsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 12:48:31 -0400
Date: Tue, 28 Aug 2012 09:48:26 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tero Kristo <t-kristo@ti.com>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Liam Girdwood <lrg@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, Benoit Cousson <b-cousson@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/14] MFD: twl4030-audio: Convert to use devm_kzalloc
Message-ID: <20120828164825.GA4534@opensource.wolfsonmicro.com>
References: <1344954162-7985-1-git-send-email-peter.ujfalusi@ti.com>
 <1344954162-7985-3-git-send-email-peter.ujfalusi@ti.com>
 <1346147410.2182.96.camel@sokoban>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346147410.2182.96.camel@sokoban>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 12:50:10PM +0300, Tero Kristo wrote:
> On Tue, 2012-08-14 at 17:22 +0300, Peter Ujfalusi wrote:
> > Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

> I think this one could use a short commit message, also about why
> kfree():s are dropped (handled internally by devm_* etc.)

Honestly I think people should be able to figure this out, it's not like
it's an obscure API nobody ever used before.
