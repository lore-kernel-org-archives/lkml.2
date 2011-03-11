Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab1CKMRI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 07:17:08 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44092 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752674Ab1CKMRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 07:17:06 -0500
Date: Fri, 11 Mar 2011 12:17:04 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marek Belisko <marek.belisko@open-nandra.com>
Cc: ben-linux@fluff.org, perex@perex.cz, tiwai@suse.de, lrg@slimlogic.co.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH RFC] arm: mini2440: Fix uda134x codec problem.
Message-ID: <20110311121704.GF1760@opensource.wolfsonmicro.com>
References: <1299703580-3957-1-git-send-email-marek.belisko@open-nandra.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299703580-3957-1-git-send-email-marek.belisko@open-nandra.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 09:46:20PM +0100, Marek Belisko wrote:
> ASoC audio for mini2440 platform in current kenrel doesn't work.
> First problem is samsung_asoc_dma device is missing in initialization.
> Next problem is with codec. Codec is initialized but never probed

Applied, thanks.  With changes like this you should really split things
up into a small patch series - if you ever find yourself writing
"Next problem..." or "Also..." then going on to describe a separate
change that's a sign that you should be writing a separate patch.
