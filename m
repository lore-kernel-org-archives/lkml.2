Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212Ab1JXMJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:09:15 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43521 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932100Ab1JXMJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:09:12 -0400
Date: Mon, 24 Oct 2011 14:09:07 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/3] ASoC: wm8940: Fix setting PLL Output clock division
 ratio
Message-ID: <20111024120907.GG6148@opensource.wolfsonmicro.com>
References: <1319427161.5773.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319427161.5773.3.camel@phoenix>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 11:32:41AM +0800, Axel Lin wrote:
> According to the datasheet:
> The PLL Output clock division ratio is controlled by BIT[5:4] of
> WM8940_GPIO register(08h).
> Current code read/write the WM8940_ADDCNTRL(07h) register which is wrong.

Applied this and patch 2, thanks.
