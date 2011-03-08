Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab1CHPeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 10:34:08 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58693 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754180Ab1CHPeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 10:34:06 -0500
Date: Tue, 8 Mar 2011 15:34:03 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Abhilash K V <abhilash.kv@ti.com>
Cc: linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, jhnikula@gmail.com, lrg@slimlogic.co.uk,
        perex@perex.cz, tiwai@suse.de
Subject: Re: [PATCH] ASoC: AM3517: Update codec name after multi-component
 update
Message-ID: <20110308153402.GA21538@opensource.wolfsonmicro.com>
References: <1299598363-32656-1-git-send-email-abhilash.kv@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299598363-32656-1-git-send-email-abhilash.kv@ti.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 09:02:43PM +0530, Abhilash K V wrote:
> The i2c client device name (".2-001a" in this case, including
> the separator period) for the AIC23 codec on the TI AM3517-EVM
> was appended to the codec_name member of am3517evm_dai to
> resolve the names mismatch happening in soc_bind_dai_link(),
> due to which the card was not getting registered.

Ached-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
