Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916Ab1EBNbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 09:31:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:62994 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757079Ab1EBNbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 09:31:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,302,1301900400"; 
   d="scan'208";a="916932444"
Date: Mon, 2 May 2011 15:31:20 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: asic3: fix build breakage from 52a7d607
Message-ID: <20110502133119.GD740@sortiz-mobl>
References: <1303329628.21545.10.camel@flow>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303329628.21545.10.camel@flow>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

On Wed, Apr 20, 2011 at 10:00:27PM +0200, Philipp Zabel wrote:
> The struct irq_data pointer is called data, not irq_data.
> Also, use irq_data_get_chip() instead of data->chip directly.
Thanks, this one is already queued on my for-linus branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
