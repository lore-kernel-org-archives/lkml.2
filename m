Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204Ab1JFHK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 03:10:26 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43732 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720Ab1JFHKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 03:10:24 -0400
Subject: Re: [PATCH 00/10] Convert wm8xxx codec drivers to use
 snd_soc_cache_sync
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Arthur <linux@wolfsonmicro.com>, Richard Purdie <rpurdie@rpsys.net>,
        Jonathan Cameron <jic23@cam.ac.uk>, Kenneth Kiraly <kiraly@lab126.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
In-Reply-To: <1317883960.13399.17.camel@phoenix>
References: <1317881417.13399.1.camel@phoenix>
	 <1317883960.13399.17.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Oct 2011 15:10:16 +0800
Message-ID: <1317885016.13399.21.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 四，2011-10-06 於 14:52 +0800，Axel Lin 提到：
> Sorry. I just found we need to set codec->cache_sync = 1 in
> SND_SOC_BIAS_OFF. Otherwise, snd_soc_cache_sync won't sync work.
> 
> Will send a v2 soon.

I take it back. sorry again.
After commit 7be4ba24 "ASoC: Mark cache as dirty when suspending",
The soc-core will set codec->cache_sync flag now.

Regards,
Axel

