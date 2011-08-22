Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab1HVKWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 06:22:04 -0400
Received: from mga14.intel.com ([143.182.124.37]:21062 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756752Ab1HVKWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 06:22:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,262,1312182000"; 
   d="scan'208";a="41031922"
Date: Mon, 22 Aug 2011 12:24:02 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Julia Lawall <julia@diku.dk>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/mfd/timberdale.c: clean up error handling code
Message-ID: <20110822102402.GM4607@sortiz-mobl>
References: <1312966036-15896-1-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312966036-15896-1-git-send-email-julia@diku.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julia,

On Wed, Aug 10, 2011 at 10:47:16AM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> In the first three cases, ioremap has been called, so iounmap is needed.  A
> new label for this is introduced, to differentiate it from err_msix, which
> is the first point at which msix_entries actually needs to be freed.
Thanks a lot, patch applied.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
