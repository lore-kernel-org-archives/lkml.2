Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605Ab1JDPFg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 11:05:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59645 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932466Ab1JDPFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 11:05:34 -0400
Date: Tue, 4 Oct 2011 16:05:32 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Mike Arthur <linux@wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/4 v2] ASoC: wm8711: Use snd_soc_update_bits for
 read-modify-write
Message-ID: <20111004150532.GJ6934@opensource.wolfsonmicro.com>
References: <1317698130.2688.8.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317698130.2688.8.camel@phoenix>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 11:15:30AM +0800, Axel Lin wrote:
> Use snd_soc_update_bits for read-modify-write register access instead of
> open-coding it using snd_soc_read and snd_soc_write
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> v2: also remove unused variable 'reg'.

Applied all the v2s incrementally, thanks.
