Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab2FTMKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 08:10:33 -0400
Received: from smtp-out-159.synserver.de ([212.40.185.159]:1030 "EHLO
	smtp-out-150.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754037Ab2FTMKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 08:10:32 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 22274
Message-ID: <4FE1BE79.5080903@metafoo.de>
Date: Wed, 20 Jun 2012 14:13:45 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@linux.intel.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Russell King <linux@arm.linux.org.uk>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Mika Westerberg <mika.westerberg@iki.fi>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] dmaengine: Add wrapper for device_tx_status callback
References: <1339438302-12417-1-git-send-email-lars@metafoo.de> <1340189662.1927.1648.camel@vkoul-udesk3>
In-Reply-To: <1340189662.1927.1648.camel@vkoul-udesk3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2012 12:54 PM, Vinod Koul wrote:
> On Mon, 2012-06-11 at 20:11 +0200, Lars-Peter Clausen wrote:
>> This patch adds a small inline wrapper for the devivce_tx_status callback of a
>> dma device. This makes the source code of users of this function a bit more
>> compact and a bit more legible.
> Applied, thanks
> 
> rest of the series should go thru ASoC tree.
> 

Thanks.

There is a compile time dependency between the patches, so this patch should
go through the ASoC tree as well, or we'll have to wait another release
before the ASoC patches can be applied.

- Lars
