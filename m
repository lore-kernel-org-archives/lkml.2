Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab1A1MZJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 07:25:09 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32877 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755031Ab1A1MZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 07:25:08 -0500
Date: Fri, 28 Jan 2011 12:25:24 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Manjunathappa, Prakash" <prakash.pm@ti.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org, stable@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: DaVinci: fix kernel panic due to uninitialized
 platform_data
Message-ID: <20110128122524.GA10350@opensource.wolfsonmicro.com>
References: <1296136063-31625-1-git-send-email-prakash.pm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296136063-31625-1-git-send-email-prakash.pm@ti.com>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 07:17:43PM +0530, Manjunathappa, Prakash wrote:
> This patch fixes the Kernel panic issue on accessing davinci_vc in
> cq93vc_probe function. struct davinci_vc is part of platform device's
> private driver data(codec->dev->p->driver_data) and this is populated
> by DaVinci Voice Codec MFD driver.
> 
> Signed-off-by: Manjunathappa, Prakash <prakash.pm@ti.com>

Applied, thanks.
