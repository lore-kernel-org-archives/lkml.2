Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629Ab1LKCyz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 21:54:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60532 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751334Ab1LKCyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 21:54:54 -0500
Date: Sun, 11 Dec 2011 10:53:59 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: Wolfram Sang <w.sang@pengutronix.de>, alsa-devel@alsa-project.org,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [alsa-devel] [PATCH 2/5] ASoC: mxs: add .owner to struct
 snd_soc_card
Message-ID: <20111211025358.GB2800@opensource.wolfsonmicro.com>
References: <cover.1323436034.git.LW@KARO-electronics.de>
 <555be1750dd09586d5eede6457f72310890274b0.1323436034.git.LW@KARO-electronics.de>
 <20111209141203.GH3327@pengutronix.de>
 <20194.7382.414612.182139@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20194.7382.414612.182139@ipc1.ka-ro>
X-Cookie: Chess tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 03:36:06PM +0100, Lothar Waßmann wrote:
> Wolfram Sang writes:

> > I can't find any other instance setting owner in snd_soc_card?

> Then that other uses are most probably faulty too.

This needs to be fixed up generally, not just for a specific driver.
