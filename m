Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab2CZGon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 02:44:43 -0400
Received: from metasoft.pl ([195.149.224.191]:50373 "EHLO smtp.metasoft.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753662Ab2CZGom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 02:44:42 -0400
X-clamdmail: clamdmail 0.18a
Message-ID: <4F701052.5000509@metasoft.pl>
Date: Mon, 26 Mar 2012 08:44:34 +0200
From: Rafal Prylowski <prylowski@metasoft.pl>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@iki.fi>
CC: H Hartley Sweeten <hartleys@visionengravers.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "rmallon@gmail.com" <rmallon@gmail.com>
Subject: Re: [PATCH] ep93xx: Implement double buffering for M2M DMA channels
References: <4F683B36.8090101@metasoft.pl> <20120321193836.GC3740@mwesterb-mobl.ger.corp.intel.com> <ADE657CA350FB648AAC2C43247A983F0020696D48E3E@AUSP01VMBX24.collaborationhost.net> <20120323070446.GC5812@mwesterb-mobl.ger.corp.intel.com> <ADE657CA350FB648AAC2C43247A983F0020696D48EEB@AUSP01VMBX24.collaborationhost.net> <20120324073207.GD5812@mwesterb-mobl.ger.corp.intel.com>
In-Reply-To: <20120324073207.GD5812@mwesterb-mobl.ger.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-03-24 08:32, Mika Westerberg wrote:
> Please try it. The point there was that we have a problem in ep93xx VIC/DMA
> code but it is totally different thing and not related to Rafal's patch. We
> can sort the VIC thing out separately IMHO. ep93xx dma in 3.3 is broken
> regardless this patch.

I think, that we can't be 100% sure that these two problems are not related
at all. If some changes to VIC/ep93xx interrupt handling etc will be send
to list, I'll test them in my configuration without my patch. If it will
help (to fix the problem I'm observing also in 3.2), then double buffering
for M2M could be much simplier.

Now, I'm trying to test mmc_spi in ep93xx and let you know what the results
are.
