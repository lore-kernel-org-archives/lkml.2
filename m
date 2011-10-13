Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab1JMKYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 06:24:38 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50055 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab1JMKYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 06:24:37 -0400
Date: Thu, 13 Oct 2011 11:24:28 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, alsa-devel@alsa-project.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [alsa-devel] linux-next: Tree for Oct 12
 (sound/soc/codecs/wm1250-ev1)
Message-ID: <20111013102427.GG1098@sirena.org.uk>
References: <20111012175425.a2e3e6e6a92265e433aeca25@canb.auug.org.au>
 <4E9634C9.3020404@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9634C9.3020404@xenotime.net>
X-Cookie: Drilling for oil is boring.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 05:46:01PM -0700, Randy Dunlap wrote:

> When no GPIO kconfig options are enabled:
> (not GPIOLIB, not GENERIC_GPIO):

As ever the consumer side GPIO API is supposed to stub itself out when
not in use.
