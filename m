Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab1JQViB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 17:38:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46940 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754518Ab1JQViA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 17:38:00 -0400
Date: Mon, 17 Oct 2011 22:37:58 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Barry Song <21cnbao@gmail.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 2/2] ASoC: ad193x: Use snd_soc_update_bits for
 read-modify-write
Message-ID: <20111017213757.GA5200@opensource.wolfsonmicro.com>
References: <1318582919.19976.1.camel@phoenix>
 <1318582987.19976.2.camel@phoenix>
 <20111014191000.GB2931@opensource.wolfsonmicro.com>
 <CAF+7xWmdNqEuVCNB=53FftFm_Ds-=o5DwVa41MDq8m0DTZnzxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF+7xWmdNqEuVCNB=53FftFm_Ds-=o5DwVa41MDq8m0DTZnzxg@mail.gmail.com>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 15, 2011 at 11:21:49AM +0800, Axel Lin wrote:

> But if you prefer also convert it to snd_soc_update_bits, I can do it.
> Let me know if I need to send a v2 for it.

It'd be nice, if only because the patch clearly isn't doing what the
changelog claims it's doing.
