Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab2CUTj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 15:39:29 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:63670 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305Ab2CUTj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 15:39:28 -0400
Date: Wed, 21 Mar 2012 21:38:36 +0200
From: Mika Westerberg <mika.westerberg@iki.fi>
To: Rafal Prylowski <prylowski@metasoft.pl>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        "rmallon@gmail.com" <rmallon@gmail.com>
Subject: Re: [PATCH] ep93xx: Implement double buffering for M2M DMA channels
Message-ID: <20120321193836.GC3740@mwesterb-mobl.ger.corp.intel.com>
References: <4F683B36.8090101@metasoft.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F683B36.8090101@metasoft.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 09:09:26AM +0100, Rafal Prylowski wrote:
> Implement double buffering for M2M DMA channels.
> 
> Signed-off-by: Rafal Prylowski <prylowski@metasoft.pl>

The subject line prefix should probably be 'dmaengine/ep93xx_dma: ' but
otherwise this looks good.

Acked-by: Mika Westerberg <mika.westerberg@iki.fi>
