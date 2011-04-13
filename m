Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262Ab1DMHkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 03:40:00 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39105 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757096Ab1DMHj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 03:39:59 -0400
Subject: Re: [alsa-devel] [PATCH 1/2] ASoC: codecs: JZ4740: Fix OOPS
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
In-Reply-To: <1302629609-21537-1-git-send-email-lars@metafoo.de>
References: <1302629609-21537-1-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 08:39:55 +0100
Message-ID: <1302680395.3600.11.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-12 at 19:33 +0200, Lars-Peter Clausen wrote:
> Commit ce6120cc(ASoC: Decouple DAPM from CODECs) changed the signature of
> snd_soc_dapm_widgets_new to take an pointer to a snd_soc_dapm_context instead of
> a snd_soc_codec. The call to snd_soc_dapm_widgets_new in jz4740_codec_dev_probe
> was not updated to reflect this change, which results in a compiletime warning
> and a runtime OOPS.
> 
> Since the core code calls snd_soc_dapm_widgets_new after the codec has been
> registered it can be dropped here.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---

Both

Acked-by: Liam Girdwood <lrg@ti.com>

