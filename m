Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192Ab2DSSnn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 14:43:43 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:43119 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761Ab2DSSnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 14:43:42 -0400
Date: Thu, 19 Apr 2012 21:42:47 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: Rafal Prylowski <prylowski@metasoft.pl>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        "rmallon@gmail.com" <rmallon@gmail.com>
Subject: Re: [PATCH v2] dmaengine/ep93xx_dma: Implement double buffering for
 M2M DMA channels
Message-ID: <20120419184247.GA877@mwesterb-mobl.lan>
References: <4F8FD884.7090403@metasoft.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F8FD884.7090403@metasoft.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 11:19:00AM +0200, Rafal Prylowski wrote:
> Add double buffering support for M2M DMA channels. Implement this by using EP93xx
> M2M DMA Buffer and Control Finite State Machines to be sure that we are not
> disabling the channel when it's actually operating.
> 
> Signed-off-by: Rafal Prylowski <prylowski@metasoft.pl>
> Tested-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Acked-by: Mika Westerberg <mika.westerberg@iki.fi>
