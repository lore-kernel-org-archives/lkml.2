Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab1JCNQ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 09:16:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55946 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932099Ab1JCNQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 09:16:50 -0400
Date: Mon, 3 Oct 2011 14:16:48 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Vinod Koul <vinod.koul@linux.intel.com>,
        Harsha Priya <priya.harsha@intel.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: Remove needless  codec->dapm.bias_level assignment
 to SND_SOC_BIAS_OFF
Message-ID: <20111003131647.GK3731@opensource.wolfsonmicro.com>
References: <1317644236.2724.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317644236.2724.1.camel@phoenix>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 08:17:16PM +0800, Axel Lin wrote:
> This assignment is done by the snd_soc_register_codec so there is no need
> to redo it in probe function of a codec driver.

Applied, thanks.
