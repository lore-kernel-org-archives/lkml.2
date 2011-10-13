Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab1JMK6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 06:58:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33888 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752440Ab1JMK6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 06:58:54 -0400
Date: Thu, 13 Oct 2011 11:58:53 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Axel Lin <axel.lin@gmail.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: ak4642: fixup cache register table
Message-ID: <20111013105852.GF5193@opensource.wolfsonmicro.com>
References: <1318335653.3573.1.camel@phoenix>
 <87ty7dl0uh.wl%kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ty7dl0uh.wl%kuninori.morimoto.gx@renesas.com>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 02:03:54AM -0700, Kuninori Morimoto wrote:
> ak4642 register was 8bit, but cache table was defined as 16bit.
> ak4642 doesn't work correctry without this patch.

Applied, thanks.
