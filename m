Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab0LTKU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 05:20:59 -0500
Received: from mga14.intel.com ([143.182.124.37]:5815 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755084Ab0LTKU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 05:20:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,201,1291622400"; 
   d="scan'208";a="364050809"
Date: Mon, 20 Dec 2010 11:20:57 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Harald Welte <HaraldWelte@viatech.com>
Subject: Re: [PATCH RESEND] mfd: Add __devexit annotation for vx855_remove
Message-ID: <20101220102056.GA11095@sortiz-mobl>
References: <1292810526.17628.4.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292810526.17628.4.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Mon, Dec 20, 2010 at 10:02:06AM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Acked-by: Harald Welte <HaraldWelte@viatech.com>
> ---
> hi Samuel,
> Looks like this patch is missing.
That one slipped through, thanks for resending it. I applied it now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
