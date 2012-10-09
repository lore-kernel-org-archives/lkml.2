Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab2JIGU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:20:28 -0400
Received: from bitmer.com ([213.157.87.50]:47459 "EHLO bitmer.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542Ab2JIGU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:20:26 -0400
Date: Tue, 9 Oct 2012 09:20:03 +0300
From: Jarkko Nikula <jarkko.nikula@bitmer.com>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Deepak Saxena <dsaxena@plexity.net>, Chris Ball <cjb@laptop.org>,
        Matt Mackall <mpm@selenic.com>, Venkatraman S <svenkatr@ti.com>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: OMAP: Trivial driver changes to remove include
 plat/cpu.h
Message-Id: <20121009092003.3f3d271a035595ef8fbb1e76@bitmer.com>
In-Reply-To: <20121008173557.10603.18539.stgit@muffinssi>
References: <20121008173452.10603.53886.stgit@muffinssi>
	<20121008173557.10603.18539.stgit@muffinssi>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Oct 2012 10:35:57 -0700
Tony Lindgren <tony@atomide.com> wrote:

> - omap-dma.c and omap-pcm.c can test the arch locally as
>   omap1 and omap2 cannot be compiled together because of
>   conflicting compiler flags
...
>  sound/soc/omap/omap-pcm.c         |    9 +++++++--

Build tested above for omap1 and omap2+.

Acked-by: Jarkko Nikula <jarkko.nikula@bitmer.com>
