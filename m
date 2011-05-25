Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932972Ab1EYPBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 11:01:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58737 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932411Ab1EYPBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 11:01:20 -0400
Date: Wed, 25 May 2011 23:01:14 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoc: wm8731: fix wm8731_check_osc() connected condition
Message-ID: <20110525150113.GC12816@opensource.wolfsonmicro.com>
References: <1306230657-28649-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306230657-28649-1-git-send-email-nicolas.ferre@atmel.com>
X-Cookie: Don't Worry, Be Happy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 11:50:57AM +0200, Nicolas Ferre wrote:
> The crystal oscillator is only enabled if the WM8731_SYSCLK_XTAL master clock
> is specified. Fix the connected() struct snd_soc_dapm_route function to take
> this into account. Oscillator is not enabled on machine that need it otherwise.

Appilied, thanks.
