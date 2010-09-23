Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964Ab0IWMEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 08:04:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50808 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752579Ab0IWMEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 08:04:45 -0400
Date: Thu, 23 Sep 2010 13:04:43 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Hsiang <Peter.Hsiang@maxim-ic.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesse Marroquin <Jesse.Marroquin@maxim-ic.com>
Subject: Re: [PATCH] ASoC: Add max98088 CODEC driver
Message-ID: <20100923120443.GF25663@rakim.wolfsonmicro.main>
References: <B2150E1E4418E1438554A300EA5040E40D469C1248@ITSVLEX06.it.maxim-ic.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B2150E1E4418E1438554A300EA5040E40D469C1248@ITSVLEX06.it.maxim-ic.internal>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 07:58:48PM -0700, Peter Hsiang wrote:

> This patch adds the MAX98088 CODEC driver.

> Signed-off-by: Peter Hsiang <peter.hsiang@maxim-ic.com>

When you submitted the driver on the 31st of August my first comment in
the review was:

| The major issue with this is that the driver needs to be updated to
| current ASoC versions - you should always be working against the trees
| that are in linux-next for new drivers.  For ASoC you should be looking
| at:

|   git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound-2.6.git

Currently you should be looking at for-next or for-2.6.37, though the
branch names will change as kernel development moves forward.

This must be rectified before the driver can be considered for inclusion
in the kernel.  As things stand the code will not compile.
