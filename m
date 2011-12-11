Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab1LKC4U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 21:56:20 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60541 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751425Ab1LKC4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 21:56:19 -0500
Date: Sun, 11 Dec 2011 10:55:21 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>,
        alsa-devel@alsa-project.org,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [alsa-devel] [PATCH 3/5] ASoC: mxs: Export symbols
 'mxs_saif_put_mclk()' and 'mxs_saif_get_mclk()'
Message-ID: <20111211025519.GC2800@opensource.wolfsonmicro.com>
References: <cover.1323436034.git.LW@KARO-electronics.de>
 <42d1579aefe3a3025f16fb4e38a4acf6b72756f7.1323436034.git.LW@KARO-electronics.de>
 <20111209141530.GI3327@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111209141530.GI3327@pengutronix.de>
X-Cookie: Chess tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 03:15:30PM +0100, Wolfram Sang wrote:
> On Fri, Dec 09, 2011 at 02:38:10PM +0100, Lothar Waßmann wrote:

> > +EXPORT_SYMBOL(mxs_saif_put_mclk);

> EXPORT_SYMBOL_GPL. I'd vote this is an implementation issue.

Yes, please - the entire subsystem is exported _GPL.
