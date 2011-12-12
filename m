Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab1LLKEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 05:04:11 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46491 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750864Ab1LLKEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 05:04:08 -0500
Date: Mon, 12 Dec 2011 18:04:03 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: Wolfram Sang <w.sang@pengutronix.de>, alsa-devel@alsa-project.org,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [alsa-devel] [PATCH 2/5] ASoC: mxs: add .owner to struct
 snd_soc_card
Message-ID: <20111212100402.GC31568@opensource.wolfsonmicro.com>
References: <cover.1323436034.git.LW@KARO-electronics.de>
 <555be1750dd09586d5eede6457f72310890274b0.1323436034.git.LW@KARO-electronics.de>
 <20111209141203.GH3327@pengutronix.de>
 <20194.7382.414612.182139@ipc1.ka-ro>
 <20111211025358.GB2800@opensource.wolfsonmicro.com>
 <20197.50444.333155.552035@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20197.50444.333155.552035@ipc1.ka-ro>
X-Cookie: Just to have it is enough.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 10:10:36AM +0100, Lothar Waßmann wrote:

> There are 84 drivers affected by this. I did not check though whether
> all of them are compilable as module.
> I could provide a patch for all of these, but I can at most do a
> compile testing for some of them.

Compile only testing is absolutely fine.
