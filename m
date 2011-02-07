Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab1BGLuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 06:50:24 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35934 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753767Ab1BGLuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 06:50:23 -0500
Date: Mon, 7 Feb 2011 11:50:21 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] ASoC: neo1973_wm8753: Move lm4857 specefic code to
 its own module
Message-ID: <20110207115021.GC10564@opensource.wolfsonmicro.com>
References: <1297033463-14577-1-git-send-email-lars@metafoo.de>
 <1297033463-14577-2-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297033463-14577-2-git-send-email-lars@metafoo.de>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 07, 2011 at 12:04:18AM +0100, Lars-Peter Clausen wrote:

> +int lm4857_add_controls(struct snd_soc_codec *codec)
> +{
> +	return snd_soc_add_controls(codec, lm4857_controls,
> +				ARRAY_SIZE(lm4857_controls));
> +}
> +EXPORT_SYMBOL_GPL(lm4857_add_controls);

If you're moving this into a standalone driver it should be updated to
register as a CODEC.
