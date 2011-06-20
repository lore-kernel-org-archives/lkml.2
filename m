Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab1FTNM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 09:12:58 -0400
Received: from mga14.intel.com ([143.182.124.37]:13275 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754161Ab1FTNMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 09:12:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,394,1304319600"; 
   d="scan'208";a="15556642"
Date: Mon, 20 Jun 2011 15:13:01 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] MFD: jz4740-adc: Use generic irq chip
Message-ID: <20110620131301.GH22420@sortiz-mobl>
References: <1307063666-10702-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307063666-10702-1-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars-Peter,

On Fri, Jun 03, 2011 at 03:14:26AM +0200, Lars-Peter Clausen wrote:
> Use the generic irq chip framework for implementing the irq chip for
> the jz4740-adc driver.
Nice, patch applied to my for-next branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
