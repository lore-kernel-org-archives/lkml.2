Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab0KYLOr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 06:14:47 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40831 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752172Ab0KYLOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 06:14:46 -0500
Date: Thu, 25 Nov 2010 11:14:45 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        Jon Smirl <jonsmirl@gmail.com>, Sergey Lapin <slapin@ossfans.org>,
        Sedji Gaouaou <sedji.gaouaou@atmel.com>,
        Jaswinder Singh Brar <jassi.brar@samsung.com>,
        Mika Westerberg <mika.westerberg@iki.fi>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 0/8] ASoC: fix resource leak in error paths
Message-ID: <20101125111444.GD22298@rakim.wolfsonmicro.main>
References: <1290668785.30158.7.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290668785.30158.7.camel@mola>
X-Cookie: Beam me up, Scotty!  It ate my phaser!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 03:06:25PM +0800, Axel Lin wrote:
> This serial of patches fix resource leak in error paths.

All applied, thanks - thanks for taking the time to do so many cleanups
recently, it's appreciated.
