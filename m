Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab1HKJbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 05:31:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44246 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753592Ab1HKJbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 05:31:50 -0400
Date: Thu, 11 Aug 2011 18:31:42 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH 1/4] ASoC: DAPM: Allow multiple mixer sources to be
 routed via the same switch
Message-ID: <20110811093140.GB18454@opensource.wolfsonmicro.com>
References: <1312948364-2587-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312948364-2587-1-git-send-email-lars@metafoo.de>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 05:52:41AM +0200, Lars-Peter Clausen wrote:
> Currently it is only possible to route one source per switch into a mixer.
> This patch modifies the code, so that it is possible to route multiple sources
> into a mixer via the same switch. One use-case for this is routing a stereo
> channel pair into a mono-mixer via the same switch.

I'd have thought the dapm_is_shared_control() stuff should handle this?
