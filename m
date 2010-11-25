Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab0KYLNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 06:13:32 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40819 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752172Ab0KYLNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 06:13:31 -0500
Date: Thu, 25 Nov 2010 11:13:29 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Artamonow <mad_soft@inbox.ru>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org,
        Eric Miao <eric.y.miao@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: fix SND_PXA2XX_LIB Kconfig warning
Message-ID: <20101125111329.GC22298@rakim.wolfsonmicro.main>
References: <1290635175-30501-1-git-send-email-mad_soft@inbox.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290635175-30501-1-git-send-email-mad_soft@inbox.ru>
X-Cookie: Beam me up, Scotty!  It ate my phaser!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 12:46:15AM +0300, Dmitry Artamonow wrote:
> Fix following warning observed when SND_PXA2XX_SOC is set and SND_ARM isn't:
> 
> warning: (SND_PXA2XX_AC97 && SOUND && !M68K && SND && SND_ARM && ARCH_PXA ||
> SND_PXA2XX_SOC && SOUND && !M68K && SND && SND_SOC && ARCH_PXA) selects
> SND_PXA2XX_LIB which has unmet direct dependencies (SOUND && !M68K && SND &&
> SND_ARM)
> 
> Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>

Applied, thanks.
