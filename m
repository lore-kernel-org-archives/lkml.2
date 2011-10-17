Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab1JQVmq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 17:42:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57970 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754251Ab1JQVmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 17:42:45 -0400
Date: Mon, 17 Oct 2011 22:42:43 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        "kuninori.morimoto.gx" <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH v4 3/7] ASoC: da7210: Add support for mute
 and zero cross controls
Message-ID: <20111017214242.GD5200@opensource.wolfsonmicro.com>
References: <1318670595.613.42.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318670595.613.42.camel@matrix>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 15, 2011 at 02:53:15PM +0530, Ashish Chavan wrote:

> +	SOC_SINGLE("ADC Left Capture Switch", DA7210_ADC, 2, 1, 0),
> +	SOC_SINGLE("ADC Right Capture Switch", DA7210_ADC, 6, 1, 0),

I'd really expect this to be a single stereo control.
