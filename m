Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab1BGLm7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 06:42:59 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49317 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753896Ab1BGLm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 06:42:58 -0500
Date: Mon, 7 Feb 2011 11:42:55 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] ASoC: neo1973_wm8753: Remove scenario management
 code.
Message-ID: <20110207114255.GB10564@opensource.wolfsonmicro.com>
References: <1297033463-14577-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297033463-14577-1-git-send-email-lars@metafoo.de>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 07, 2011 at 12:04:17AM +0100, Lars-Peter Clausen wrote:

> +	snd_soc_dapm_disable_pin(codec, "Audio Out");
> +	snd_soc_dapm_disable_pin(codec, "GSM Line Out");
> +	snd_soc_dapm_disable_pin(codec, "GSM Line In");
> +	snd_soc_dapm_disable_pin(codec, "Headset Mic");
> +	snd_soc_dapm_disable_pin(codec, "Call Mic");

This will mean that it's impossible to enable most (if not all) of the
audio paths in the system which probably isn't what you want.
