Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab2DPPgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:36:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:26735 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461Ab2DPPgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:36:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="130196913"
Date: Mon, 16 Apr 2012 17:45:07 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Paul Parsons <lost.distance@yahoo.com>
Cc: linux-kernel@vger.kernel.org, philipp.zabel@gmail.com
Subject: Re: [PATCH 3/3] mfd: asic3: Add PCMCIA/CF support
Message-ID: <20120416154507.GI24130@sortiz-mobl>
References: <1333644304.97070.YahooMailClassic@web29013.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333644304.97070.YahooMailClassic@web29013.mail.ird.yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Thu, Apr 05, 2012 at 05:45:04PM +0100, Paul Parsons wrote:
> This patch is part of a set which adds PCMCIA/CF support for the hx4700.
> This patch adds asic3_set_register() calls to:
> 1. Enable the PCMCIA/CF in asic3_probe().
> 2. Disable the PCMCIA/CF in asic3_remove().
> 
> Signed-off-by: Paul Parsons <lost.distance@yahoo.com>
> Cc: Philipp Zabel <philipp.zabel@gmail.com>
> ---
>  drivers/mfd/asic3.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
