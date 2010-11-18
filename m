Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751104Ab0KRLHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 06:07:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36702 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750867Ab0KRLHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 06:07:33 -0500
Date: Thu, 18 Nov 2010 11:07:31 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jesse Marroquin <jesse.marroquin@maxim-ic.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Peter Hsiang <Peter.Hsiang@maxim-ic.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ASoC: Add support for MAX98089 CODEC
Message-ID: <20101118110731.GC7233@rakim.wolfsonmicro.main>
References: <4CE43A80.4050209@maxim-ic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE43A80.4050209@maxim-ic.com>
X-Cookie: Pass with care.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 02:26:40PM -0600, Jesse Marroquin wrote:
> This patch adds initial support for the MAX98089 CODEC.

Applied, thanks.  One thing:

>  struct max98088_priv {
>         u8 reg_cache[M98088_REG_CNT];
> +       enum max98088_type devtype;

You currently never actually read the devtype anywhere - if the devices
really are fully register compatible (eg, if the differences are in
physical or electrical characteristics which aren't visible to software)
then there's no need to bother doing this, though equally well it does
no harm.
