Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab1EEOCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 10:02:48 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37420 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271Ab1EEOCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 10:02:47 -0400
Date: Thu, 5 May 2011 15:02:39 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ashish Jangam <Ashish.Jangam@kpitcummins.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Dajun Chen <Dajun.Chen@diasemi.com>
Subject: Re: [PATCHv1 -next] LEDS: LED module of DA9052 PMIC driver
Message-ID: <20110505140238.GB26651@sirena.org.uk>
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BA5B8D9@KCINPUNHJCMS01.kpit.com> <20110504135833.c44c372d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504135833.c44c372d.akpm@linux-foundation.org>
X-Cookie: <Omnic> another .sig addition
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 01:58:33PM -0700, Andrew Morton wrote:
> Ashish Jangam <Ashish.Jangam@kpitcummins.com> wrote:

> > LED Driver for Dialog Semiconductor DA9052 PMICs.

> I don't know what to do with this patch.

> > +	depends on PMIC_DA9052

> Because it is unusable as a standalone patch.

> What is your merge plan for PMIC_DA9052 support?  Please work one out,
> and tell us about it in each and every patch so that the people who are
> receiving these emails can work out what to do with them.

Ideally you should do this by submitting all your patches in a single
patch series.
