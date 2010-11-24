Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab0KXL12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 06:27:28 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43819 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab0KXL11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 06:27:27 -0500
Date: Wed, 24 Nov 2010 11:27:25 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ASoC: wm8961 - clear WM8961_DACSLOPE bit for
	normal mode
Message-ID: <20101124112724.GA13507@sirena.org.uk>
References: <1290565233.5506.2.camel@mola> <1290595712.3332.4.camel@odin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290595712.3332.4.camel@odin>
X-Cookie: I invented skydiving in 1989!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 10:48:32AM +0000, Liam Girdwood wrote:
> On Wed, 2010-11-24 at 10:20 +0800, Axel Lin wrote:
> > DACSLOPE bit of Register 06h ADC and DAC Control 2:
> >         0: Normal mode
> >         1: Sloping stop-band mode
> > 
> > Thus in the case of normal mode, we should clear DACSLOPE bit.
> > 
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>

> Both

> Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>

And applied.  Axel, the list for ALSA patches is alsa-devel@alsa-project.org
