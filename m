Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab1JLO4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 10:56:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34894 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751915Ab1JLO4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 10:56:33 -0400
Date: Wed, 12 Oct 2011 15:56:32 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg@ti.com, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        kuninori.morimoto.gx@renesas.com,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH 4/9] ASoC: da7210: Add support for mute and
 zero cross controls
Message-ID: <20111012145631.GQ3647@opensource.wolfsonmicro.com>
References: <1318431695.12107.411.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318431695.12107.411.camel@matrix>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 08:31:35PM +0530, Ashish Chavan wrote:

> +	/* Mute controls */
> +	SOC_SINGLE("Mic Left Mute Switch", DA7210_MIC_L, 3, 1, 0),
> +	SOC_SINGLE("Mic Right Mute Switch", DA7210_MIC_R, 3, 1, 0),

Should be a double control.

> +	SOC_SINGLE("DAC Soft Mute Rate", DA7210_SOFTMUTE, 0, 0X7, 0),

0x7.
