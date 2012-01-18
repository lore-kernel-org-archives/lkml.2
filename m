Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380Ab2ARMkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 07:40:43 -0500
Received: from linux-sh.org ([111.68.239.195]:34975 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754371Ab2ARMkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 07:40:41 -0500
Date: Wed, 18 Jan 2012 21:40:33 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH 1/2] dma: sh_dma: not all SH DMAC implementations support MEMCPY
Message-ID: <20120118124033.GI8182@linux-sh.org>
References: <Pine.LNX.4.64.1201181012130.28782@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1201181012130.28782@axis700.grange>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 10:14:25AM +0100, Guennadi Liakhovetski wrote:
> Add a flag to allow platforms to specify, whether a DMAC instance supports
> the MEMCPY operation. To avoid regressions, preserve the current default.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

This series looks fine to me.

Acked-by: Paul Mundt <lethal@linux-sh.org>
