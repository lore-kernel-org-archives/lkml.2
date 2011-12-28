Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab1L1Lhw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 06:37:52 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32952 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753681Ab1L1Lhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 06:37:50 -0500
Date: Wed, 28 Dec 2011 11:37:46 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Arnaud Patard <arnaud.patard@rtp-net.org>,
        Andrew Lunn <andrew@lunn.ch>, Nicolas Pitre <nico@fluxnic.net>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH v2] ASoC: Fix build error in
 sound/soc/kirkwood/kirkwood-i2s.c
Message-ID: <20111228113745.GD24405@opensource.wolfsonmicro.com>
References: <1325059522.18468.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325059522.18468.4.camel@phoenix>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 28, 2011 at 04:05:22PM +0800, Axel Lin wrote:
> Since commit db33f4de "ARM: Orion: Remove address map info from all platform data structures",
> the dram is removed from struct kirkwood_asoc_platform_data.

Applied, thanks.
