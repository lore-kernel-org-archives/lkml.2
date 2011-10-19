Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab1JSMJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 08:09:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49671 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754474Ab1JSMJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 08:09:03 -0400
Date: Wed, 19 Oct 2011 13:09:01 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Zeng Zhaoming <zhaoming.zeng@freescale.com>,
        Wolfram Sang <w.sang@pengutronix.de>, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/2] ASoC: sgtl5000: Fix define for SGTL5000_BIAS_R_MASK
Message-ID: <20111019120901.GD3107@opensource.wolfsonmicro.com>
References: <1318992896.7128.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318992896.7128.1.camel@phoenix>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 10:54:56AM +0800, Axel Lin wrote:
> According to the datasheet:
> CHIP_MIC_CTRL 0x002A

Applied both, thanks.
