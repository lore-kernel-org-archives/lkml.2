Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab1AVXcy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 18:32:54 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47239 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752818Ab1AVXcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 18:32:53 -0500
Date: Sat, 22 Jan 2011 23:33:09 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, "for 2.6.37" <stable@kernel.org>
Subject: Re: [PATCH] ASoC: Fix codec device id format used by some dai_links
Message-ID: <20110122233309.GA22799@opensource.wolfsonmicro.com>
References: <1295735888-25527-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295735888-25527-1-git-send-email-lars@metafoo.de>
X-Cookie: Chess tonight.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 22, 2011 at 11:38:07PM +0100, Lars-Peter Clausen wrote:

>  sound/soc/imx/wm1133-ev1.c                     |    2 +-

This at least is definitely wrong, the WM835x CODEC here is registered
as a platform device.  Please also check current kernels, a bunch of
these are already fixed.
