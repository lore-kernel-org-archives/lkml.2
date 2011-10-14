Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933239Ab1JNTgQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 15:36:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51788 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933143Ab1JNTgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 15:36:13 -0400
Date: Fri, 14 Oct 2011 20:36:07 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 3/3] ASoC: wm8961: Convert codec->hw_read to snd_soc_read
Message-ID: <20111014193606.GI2931@opensource.wolfsonmicro.com>
References: <1318556120.6379.1.camel@phoenix>
 <1318556272.6379.4.camel@phoenix>
 <1318556354.6379.5.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318556354.6379.5.camel@phoenix>
X-Cookie: Chess tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 09:39:14AM +0800, Axel Lin wrote:
> codec->hw_read is broken now, let's covert to snd_soc_read.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks.
