Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab1E0VPG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 17:15:06 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53792 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205Ab1E0VPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 17:15:04 -0400
Message-ID: <4DE0140E.6050905@ti.com>
Date: Fri, 27 May 2011 22:13:50 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Hsiang <peter.hsiang@maxim-ic.com>,
        Peter Hsiang <cdefgab1288@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: [PATCH] ASoC: Remove redundant freq assignment for max98095->sysclk/max98088->sysclk
References: <1306510253.19556.36.camel@phoenix>
In-Reply-To: <1306510253.19556.36.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/05/11 16:30, Axel Lin wrote:
> Current implementation set max98095->sysclk/max98088->sysclk to freq twice.
> Set it once is enough, this patch removes the first assignment in case
> we may set invalid clock frequency to max98095->sysclk/max98088->sysclk.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> hi Peter,
> I don't have this hardware handy. Can you help to test it?
> Thanks,
> Axel
> 

Acked-by: Liam Girdwood <lrg@ti.com>
