Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933Ab1EYPBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 11:01:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58730 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932411Ab1EYPBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 11:01:11 -0400
Date: Wed, 25 May 2011 23:01:04 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoc: sam9g20_wm8731: use the proper SYSCKL value
Message-ID: <20110525150103.GB12816@opensource.wolfsonmicro.com>
References: <1306230676-28688-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306230676-28688-1-git-send-email-nicolas.ferre@atmel.com>
X-Cookie: Don't Worry, Be Happy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 11:51:16AM +0200, Nicolas Ferre wrote:
> at91sam9g20 is providing master clock to wm8731: not using a crystal but an
> external MCLK. We can avoid conflict and save power using WM8731_SYSCLK_MCLK as
> we do not need oscillator to be powered.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Applied, thanks.
