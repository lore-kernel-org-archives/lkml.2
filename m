Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab2JIJBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 05:01:48 -0400
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:55010 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754301Ab2JIJBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 05:01:45 -0400
Message-ID: <5073E84E.4090408@ti.com>
Date: Tue, 09 Oct 2012 11:03:10 +0200
From: =?UTF-8?B?UMOpdGVyIFVqZmFsdXNp?= <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120917 Thunderbird/15.0.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, Deepak Saxena <dsaxena@plexity.net>,
        Chris Ball <cjb@laptop.org>, Matt Mackall <mpm@selenic.com>,
        Venkatraman S <svenkatr@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: OMAP: Trivial driver changes to remove include
 plat/cpu.h
References: <20121008173452.10603.53886.stgit@muffinssi> <20121008173557.10603.18539.stgit@muffinssi>
In-Reply-To: <20121008173557.10603.18539.stgit@muffinssi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2012 07:35 PM, Tony Lindgren wrote:

> - omap-dma.c and omap-pcm.c can test the arch locally as
>   omap1 and omap2 cannot be compiled together because of
>   conflicting compiler flags

>  sound/soc/omap/omap-pcm.c         |    9 +++++++--

Tony: is this going to be included in 3.7?

Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
