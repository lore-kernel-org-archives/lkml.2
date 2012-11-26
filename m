Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab2KZKuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 05:50:04 -0500
Received: from mga02.intel.com ([134.134.136.20]:41734 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755015Ab2KZKuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 05:50:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,319,1352102400"; 
   d="scan'208";a="224378130"
Date: Mon, 26 Nov 2012 11:49:57 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lars Poeschel <poeschel@lemonage.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-next] mfd: viperboard: do version query in dma memory
Message-ID: <20121126104957.GO12685@sortiz-mobl>
References: <201211261124.53774.poeschel@lemonage.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201211261124.53774.poeschel@lemonage.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars,

On Mon, Nov 26, 2012 at 11:24:53AM +0100, Lars Poeschel wrote:
> From: Lars Poeschel <poeschel@lemonage.de>
> 
> The query for the viperboard version was done with memory buffer
> on the stack but usb transfers need dma capable memory buffer.
> This is fixed now.
> 
> Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
> ---
>  drivers/mfd/viperboard.c |    9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
