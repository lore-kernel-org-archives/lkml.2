Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab1JSLH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 07:07:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36337 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750870Ab1JSLHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 07:07:24 -0400
Date: Wed, 19 Oct 2011 12:07:22 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Barry Song <21cnbao@gmail.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH v2] ASoC: ad193x: Use snd_soc_update_bits for
 read-modify-write
Message-ID: <20111019110722.GA3107@opensource.wolfsonmicro.com>
References: <1318890308.15935.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318890308.15935.0.camel@phoenix>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 06:25:08AM +0800, Axel Lin wrote:
> Use snd_soc_update_bits for read-modify-write register access instead of
> open-coding it using snd_soc_read and snd_soc_write

Applied, thanks.
