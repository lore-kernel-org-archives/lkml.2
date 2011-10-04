Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab1JDLFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 07:05:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58828 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754082Ab1JDLFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 07:05:04 -0400
Date: Tue, 4 Oct 2011 12:05:02 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Mike Arthur <linux@wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/4] ASoC: wm8711: Use snd_soc_update_bits for
 read-modify-write
Message-ID: <20111004110502.GH3250@opensource.wolfsonmicro.com>
References: <1317693345.2688.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317693345.2688.1.camel@phoenix>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 09:55:45AM +0800, Axel Lin wrote:
> Use snd_soc_update_bits for read-modify-write register access instead of
> open-coding it using snd_soc_read and snd_soc_write

Applied all four, thanks.  There's rather more examples of this in the
code base that could be fixed if you're keen :)
