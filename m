Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033Ab1JNTeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 15:34:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51762 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932103Ab1JNTef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 15:34:35 -0400
Date: Fri, 14 Oct 2011 20:34:33 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Arnaud Patard <arnaud.patard@rtp-net.org>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/3] ASoC: alc5623: Convert codec->hw_read to snd_soc_read
Message-ID: <20111014193433.GG2931@opensource.wolfsonmicro.com>
References: <1318556120.6379.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318556120.6379.1.camel@phoenix>
X-Cookie: Chess tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 09:35:20AM +0800, Axel Lin wrote:
> codec->hw_read is broken now, let's covert to snd_soc_read.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks.
