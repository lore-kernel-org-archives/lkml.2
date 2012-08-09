Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab2HIKIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 06:08:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49220 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752402Ab2HIKIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 06:08:05 -0400
Date: Thu, 9 Aug 2012 11:08:03 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Misael Lopez Cruz <misael.lopez@ti.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [ 017/109] ASoC: dapm: Fix locking during codec shutdown
Message-ID: <20120809100803.GG24328@opensource.wolfsonmicro.com>
References: <20120807222043.089735600@linuxfoundation.org>
 <20120807222044.607925717@linuxfoundation.org>
 <20120808211311.GA5654@herton-Z68MA-D2H-B3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120808211311.GA5654@herton-Z68MA-D2H-B3>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 06:13:12PM -0300, Herton Ronaldo Krzesinski wrote:

Always delete irrelevant text from your quotes.

> Doesn't build on 3.4:

> linux-stable/sound/soc/soc-dapm.c: In function 'soc_dapm_shutdown_codec':
> linux-stable/sound/soc/soc-dapm.c:3226:18: error: 'struct snd_soc_card' has no member named 'dapm_mutex'
> linux-stable/sound/soc/soc-dapm.c:3251:20: error: 'struct snd_soc_card' has no member named 'dapm_mutex'

> It seems this patch should be dropped as when it was applied to 3.2, is
> that correct?

Yes.
