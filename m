Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab1FGIuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 04:50:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51026 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751834Ab1FGIuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 04:50:20 -0400
Date: Tue, 7 Jun 2011 09:50:19 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] ASoC: Blackfin: bf5xx-ad1836: Fix codec device name
Message-ID: <20110607085018.GC18544@opensource.wolfsonmicro.com>
References: <1307435086-29877-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307435086-29877-1-git-send-email-lars@metafoo.de>
X-Cookie: Avoid reality at all costs.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 10:24:46AM +0200, Lars-Peter Clausen wrote:
> Fix the codec_name field of the dai_link to match the actual device name
> of the codec. Otherwise the card won't be instantiated.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

Applied, thanks.
