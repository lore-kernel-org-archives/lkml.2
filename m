Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab1LLKKB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 05:10:01 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58312 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751105Ab1LLKKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 05:10:00 -0500
Date: Mon, 12 Dec 2011 18:09:56 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: alsa-devel@alsa-project.org, Dong Aisheng-B29396 <B29396@freescale.com>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH v2] Export symbols 'mxs_saif_put_mclk()' and
 'mxs_saif_get_mclk()'
Message-ID: <20111212100954.GD31568@opensource.wolfsonmicro.com>
References: <1323683044-11694-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1323683044-11694-1-git-send-email-LW@KARO-electronics.de>
X-Cookie: Just to have it is enough.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 10:44:04AM +0100, Lothar Waﬂmann wrote:
> Fixes the following errors with MXS sound support built as module:
> |ERROR: "mxs_saif_put_mclk" [sound/soc/mxs/snd-soc-mxs-sgtl5000.ko] undefined!
> |ERROR: "mxs_saif_get_mclk" [sound/soc/mxs/snd-soc-mxs-sgtl5000.ko] undefined!
> 
> Signed-off-by: Lothar Waﬂmann <LW@KARO-electronics.de>

This looks fine but doesn't seem to apply easily to anything immediately
- can you rebase against current code please?
