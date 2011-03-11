Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab1CKMOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 07:14:17 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56737 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab1CKMOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 07:14:16 -0500
Subject: Re: [PATCH RFC] arm: mini2440: Fix uda134x codec problem.
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Marek Belisko <marek.belisko@open-nandra.com>
Cc: ben-linux@fluff.org, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <1299703580-3957-1-git-send-email-marek.belisko@open-nandra.com>
References: <1299703580-3957-1-git-send-email-marek.belisko@open-nandra.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Mar 2011 12:14:11 +0000
Message-ID: <1299845651.3394.47.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-09 at 21:46 +0100, Marek Belisko wrote:
> ASoC audio for mini2440 platform in current kenrel doesn't work.
> First problem is samsung_asoc_dma device is missing in initialization.
> Next problem is with codec. Codec is initialized but never probed
> because no platform_device exist for codec driver. It leads to errors
> during codec binding to asoc dai. Next problem was platform data which
> was passed from board to asoc main driver but not passed to codec when
> called codec_soc_probe().
> 
> Following patch should fix issues. But not sure if in correct way.
> Please review.
> 
> Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>

Acked-by: Liam Girdwood <lrg@ti.com>

