Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab2ELTdl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 15:33:41 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46173 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332Ab2ELTdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 15:33:39 -0400
Date: Sat, 12 May 2012 22:32:40 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: Vinod Koul <vinod.koul@linux.intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, rmk <rmk@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] dmaengine: fix cyclic dma usage
Message-ID: <20120512193240.GA446@mwesterb-mobl.lan>
References: <1336717449.15424.1585.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336717449.15424.1585.camel@vkoul-udesk3>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 11:54:09AM +0530, Vinod Koul wrote:
> 
> >From 24db9e25a31ac46327253f11908463c48518dec8 Mon Sep 17 00:00:00 2001
> From: Vinod Koul <vinod.koul@linux.intel.com>
> Date: Fri, 11 May 2012 11:48:21 +0530
> Subject: [PATCH] dmaengine: fix cyclic dma usage
> 
> for cyclic dma, dont mark the descriptor as complete.
> Fix the remaining users of cyclic dma which do so
> 
> Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>

On ep93xx works perfectly.

Tested-by: Mika Westerberg <mika.westerberg@iki.fi>
