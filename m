Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418Ab1ITIa6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 04:30:58 -0400
Received: from mga14.intel.com ([143.182.124.37]:13801 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444Ab1ITIa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 04:30:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,410,1312182000"; 
   d="scan'208";a="18712339"
Date: Tue, 20 Sep 2011 10:33:40 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: jz4740-adc: Fix generic irq chip ack function name.
Message-ID: <20110920083340.GS32263@sortiz-mobl>
References: <1316441875-2161-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316441875-2161-1-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars,

On Mon, Sep 19, 2011 at 04:17:55PM +0200, Lars-Peter Clausen wrote:
> In commit 659fb32d1b6("genirq: replace irq_gc_ack() with {set,clr}_bit
> variants"), irq_gc_ack was renamed to irq_gc_ack_set_bit. The jz4740-adc
> driver still uses the old name which results in a compile error.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
> Samuel, it would be good if this fix could make it into 3.1
I will try to have it merged. For now, it's on my for-next branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
