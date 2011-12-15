Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778Ab1LOGKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 01:10:21 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49764 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab1LOGKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 01:10:19 -0500
Date: Thu, 15 Dec 2011 06:10:17 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the sound-asoc tree
Message-ID: <20111215061017.GB24287@sirena.org.uk>
References: <20111215143832.3d1f01c73e78804c479f4340@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111215143832.3d1f01c73e78804c479f4340@canb.auug.org.au>
X-Cookie: Not recommended for children.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 02:38:32PM +1100, Stephen Rothwell wrote:

> Caused by commit f6a9336879ca ("ASoC: Convert wm8993 to devm_kzalloc
> ()").  I really should not be seeing this sort of build problem ...

So, the big problem with this stuff is that I can't usefully do much
with my for-next tree directly except for build test it and it's
difficult to usefully do anything with the resulting binaries especially
as the configurations which usually turn things up are generally very
slow to build.  This means I tend to mostly test on my work tree which
does contain some other code (often code which is required in order to
do an actual test) with substantially different configurations and pure
for-next tests tend to drop off the end of the day.  Doing them in
parallel tends not to work so well due to the I/O scheduler issues and
the impact on disk cache.

In this case the fix for the typo got squashed into a change that isn't
published yet by mistake.
