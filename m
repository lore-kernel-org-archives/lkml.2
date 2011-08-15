Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab1HOX0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 19:26:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53243 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751991Ab1HOXZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 19:25:59 -0400
Date: Tue, 16 Aug 2011 08:25:51 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH 1/4] ASoC: DAPM: Allow multiple mixer sources to be
 routed via the same switch
Message-ID: <20110815232549.GA14003@opensource.wolfsonmicro.com>
References: <1313432124-22591-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313432124-22591-1-git-send-email-lars@metafoo.de>
X-Cookie: It's all in the mind, ya know.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 08:15:21PM +0200, Lars-Peter Clausen wrote:
> Currently it is only possible to route one source per switch into a mixer.
> This patch modifies the code, so that it is possible to route multiple sources
> into a mixer via the same switch. One use-case for this is routing a stereo
> channel pair into a mono-mixer via the same switch.

Applied, thanks.
