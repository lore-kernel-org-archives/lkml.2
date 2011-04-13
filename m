Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab1DMRgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 13:36:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57885 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751126Ab1DMRgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 13:36:05 -0400
Date: Wed, 13 Apr 2011 10:36:14 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ASoC: codecs: JZ4740: Fix OOPS
Message-ID: <20110413173614.GE18008@opensource.wolfsonmicro.com>
References: <1302629609-21537-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302629609-21537-1-git-send-email-lars@metafoo.de>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 07:33:28PM +0200, Lars-Peter Clausen wrote:
> Commit ce6120cc(ASoC: Decouple DAPM from CODECs) changed the signature of
> snd_soc_dapm_widgets_new to take an pointer to a snd_soc_dapm_context instead of
> a snd_soc_codec. The call to snd_soc_dapm_widgets_new in jz4740_codec_dev_probe

Applied both, thanks.
