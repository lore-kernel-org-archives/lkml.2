Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933147Ab2GEOhv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 10:37:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:16676 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932975Ab2GEOhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 10:37:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="188756867"
Date: Thu, 5 Jul 2012 16:49:13 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Graeme Gregory <gg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com, s-guiriec@ti.com
Subject: Re: [PATCH 2/3] MFD: add missing hunk to change irq to clear on read
Message-ID: <20120705144913.GF18200@sortiz-mobl>
References: <1340368581-11882-1-git-send-email-gg@slimlogic.co.uk>
 <1340368581-11882-3-git-send-email-gg@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340368581-11882-3-git-send-email-gg@slimlogic.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Graeme,

On Fri, Jun 22, 2012 at 01:36:19PM +0100, Graeme Gregory wrote:
> During conversion to regmap_irq this hunk was missing being moved
> to MFD driver to put the chip into clear on read mode. Also as slave
> is now set use it to determine which slave for the register call.
> 
> Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> ---
>  drivers/mfd/palmas.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
Applied as well, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
