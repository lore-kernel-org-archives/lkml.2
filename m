Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab1JXKK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 06:10:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39062 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754544Ab1JXKKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 06:10:23 -0400
Date: Mon, 24 Oct 2011 12:10:21 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [RFC][PATCH 3/3] ASoC: wm8940: Do not left shift the div
 parameter in wm8940_set_dai_clkdiv
Message-ID: <20111024101021.GC6148@opensource.wolfsonmicro.com>
References: <1319427161.5773.3.camel@phoenix>
 <1319427312.5773.6.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319427312.5773.6.camel@phoenix>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 11:35:12AM +0800, Axel Lin wrote:
> Just check with other codec drivers, we do left shit div for
> the corresponding bits from the caller in all other drivers.
> I don't find the caller calling wm8940_set_dai_clkdiv now,
> just make the behavior consistent with other drivers.

The semantics for the clkdivs are entirely defined by the individual
drivers - there's no actual standard here and I guess this may break
some out of tree machines that people have.  If we're going to a cleanup
here it'd be better to improve the driver to figure out the divider
configurations automatically as far as possible.
