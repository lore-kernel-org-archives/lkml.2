Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab2FNRHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 13:07:39 -0400
Received: from antcom.de ([188.40.178.216]:46168 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756062Ab2FNRHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 13:07:38 -0400
Message-ID: <4FDA1A54.3020206@antcom.de>
Date: Thu, 14 Jun 2012 19:07:32 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com
Subject: Re: [PATCH 4/14] ARM: LPC32xx: Add DMA configuration to platform
 data
References: <1339412537-24485-1-git-send-email-stigge@antcom.de> <1339412537-24485-5-git-send-email-stigge@antcom.de> <20120611111029.GF11168@n2100.arm.linux.org.uk>
In-Reply-To: <20120611111029.GF11168@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

thanks for your note!

On 11/06/12 13:10, Russell King - ARM Linux wrote:
> On Mon, Jun 11, 2012 at 01:02:07PM +0200, Roland Stigge wrote:
>> +static int pl08x_get_signal(struct pl08x_dma_chan *ch)
>> +{
>> +	return ch->cd->min_signal;
>> +}
>> +
>> +static void pl08x_put_signal(struct pl08x_dma_chan *ch)
>> +{
>> +}
> 
> These change in my unstable/dma-pl08x branch, patches have been posted
> already, but I don't deem them to be totally stable yet.  Waiting on
> OMAP people to get their mainline kernel restored to a buildable state
> so I can continue my DMA engine work.

We have a few options here:

1) Take the patch as I posted it (needs adjustments as soon as the API
changed and becomes stable)

2) Remove the DMA related patches from the LPC32xx series for now (which
would be unfortunate)

3) Let me build upon some tree that already looks worthwhile to play
with already (which one?)

What would you suggest?

Thanks in advance,

Roland
