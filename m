Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab1JQVlL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 17:41:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46964 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754090Ab1JQVlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 17:41:10 -0400
Date: Mon, 17 Oct 2011 22:41:07 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        "kuninori.morimoto.gx" <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH v3 2/8] ASoC: da7210: Add support for DAPM
Message-ID: <20111017214107.GC5200@opensource.wolfsonmicro.com>
References: <1318590098.12107.509.camel@matrix>
 <20111014192008.GD2931@opensource.wolfsonmicro.com>
 <1318666803.613.21.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318666803.613.21.camel@matrix>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 15, 2011 at 01:50:03PM +0530, Ashish Chavan wrote:

> There are two type of registers for all IOs (HP, MIC, AUX) as well as
> DAC and ADC. One type of registers control individual enable and disable
> of IO, while other set of register controls the standby mode of that
> particular IO. e.g. For ADC,

What are "enable and disable" in this context?  What do they do if not
put the part of the chip into a low power mode?  This is an intriguing
hardware design and it really needs some documentation in the driver,
right now it's just far too obscure and the driver looks buggy on code
inspection.
