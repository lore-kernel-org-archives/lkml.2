Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922Ab1L3CAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 21:00:47 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37028 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754604Ab1L3CAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 21:00:45 -0500
Date: Fri, 30 Dec 2011 02:00:42 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/3] ASoC: pxa: Convert poodle to use
 snd_soc_register_card()
Message-ID: <20111230020041.GC9737@opensource.wolfsonmicro.com>
References: <1325207771.9599.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325207771.9599.1.camel@phoenix>
X-Cookie: So this is it.  We're going to die.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 30, 2011 at 09:16:11AM +0800, Axel Lin wrote:
> Use snd_soc_register_card() instead of creating a "soc-audio" platform device.

Applied all, thanks.
