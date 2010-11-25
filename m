Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab0KYLL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 06:11:27 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40796 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751441Ab0KYLL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 06:11:26 -0500
Date: Thu, 25 Nov 2010 11:11:23 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Manuel Lauss <mano@roarinelk.homelinux.net>,
        Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: Call snd_soc_unregister_dais instead of
 snd_soc_unregister_dai in sh4_soc_dai_remove
Message-ID: <20101125111122.GA22298@rakim.wolfsonmicro.main>
References: <1290677035.1928.3.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290677035.1928.3.camel@mola>
X-Cookie: Beam me up, Scotty!  It ate my phaser!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 05:23:55PM +0800, Axel Lin wrote:
> We call snd_soc_register_dais() in sh4_soc_dai_probe(),
> thus we should call snd_soc_unregister_dais() in sh4_soc_dai_remove().

Applied, thanks.
