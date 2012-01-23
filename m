Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab2AWKre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 05:47:34 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56641 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab2AWKrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 05:47:25 -0500
Date: Mon, 23 Jan 2012 10:47:22 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: linux-next: build failure after merge of the sound-asoc tree
Message-ID: <20120123104722.GA9681@sirena.org.uk>
References: <20120123121422.f3e41d97bae580544abfab63@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120123121422.f3e41d97bae580544abfab63@canb.auug.org.au>
X-Cookie: Many a family tree needs trimming.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 12:14:22PM +1100, Stephen Rothwell wrote:

> Caused by commit 899896379670 ("ASoC: sgtl5000: Convert to table based
> DAPM and control init").  Please at least build this stuff :-(

Mainline doesn't build (and wouldn't usefully run) for any of my
interesting configs right now which does tend to push testing of -next
down the priority list.  Hopefully the fixes will make it into mainline
at some point soon.
