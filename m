Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934802Ab1JFHL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 03:11:26 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37358 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720Ab1JFHLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 03:11:25 -0400
Subject: Re: [RFC][PATCH v2] ASoC: ak4535: convert to soc-cache
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1317884726.13399.19.camel@phoenix>
References: <1317884726.13399.19.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Oct 2011 15:11:18 +0800
Message-ID: <1317885078.13399.22.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 四，2011-10-06 於 15:05 +0800，Axel Lin 提到：
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> v2: Set codec->cache_sync = 1 before calling snd_soc_cache_sync().
> 
Pls ignore this v2. 

After commit 7be4ba24 "ASoC: Mark cache as dirty when suspending",
The soc-core will set codec->cache_sync flag now.

Regards,
Axel

