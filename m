Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab1GYQPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 12:15:45 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41425 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab1GYQPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 12:15:42 -0400
Date: Mon, 25 Jul 2011 16:47:39 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Vinod Koul <vkoul@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>, vinod.koul@intel.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: add helper function for slave_single
Message-ID: <20110725154739.GD14955@n2100.arm.linux.org.uk>
References: <1311608235.8206.24.camel@vkoul-mobl4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311608235.8206.24.camel@vkoul-mobl4>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 09:07:15PM +0530, Vinod Koul wrote:
> >From af9afd16e9954edb45f0cf71834653133d75e79c Mon Sep 17 00:00:00 2001
> From: Vinod Koul <vinod.koul@intel.com>
> Date: Mon, 25 Jul 2011 19:57:52 +0530
> Subject: [PATCH] dmaengine: add helper function for slave_single
> 
> For clients which require a single slave transfer and dont want to be bothered
> about the scatterlist api, this helper gives simple API for this transfer and
> creates single scatterlist for DMA API
> 
> Idea from Russel King

Please correct this, thanks.
