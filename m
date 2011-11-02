Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab1KBVoK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 17:44:10 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50383 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab1KBVoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 17:44:08 -0400
Date: Wed, 2 Nov 2011 21:44:02 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Message-ID: <20111102214402.GA31393@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Cookie: There Is No Cabal.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.41.29.181
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: ASoC and regmap trees have moved back to kernel.org
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Please update my git trees in -next to use kernel.org again:

ASoC:
   git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-next

regmap:
   git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git for-next

Please leave the regulator tree where it is for now, Liam's kernel.org
account will hopefully be being restored shortly so he can take that
over again.

Thanks,
Mark
