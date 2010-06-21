Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337Ab0FUEkw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 00:40:52 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:36728 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab0FUEku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 00:40:50 -0400
Date: Mon, 21 Jun 2010 13:40:30 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org,
       "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-mmc@vger.kernel.org
Subject: Re: [PATCH] initialise DMA engine before MMC
Message-ID: <20100621044030.GC29997@linux-sh.org>
References: <Pine.LNX.4.64.1006071312060.12965@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1006071312060.12965@axis700.grange>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 07, 2010 at 01:16:36PM +0200, Guennadi Liakhovetski wrote:
> To use DMA engine based DMA with MMC in a non-modular build, the DMA 
> engine has to initialise before MMC.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Dan, any objections to this?
