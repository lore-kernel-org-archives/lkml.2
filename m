Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab2GPN1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 09:27:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:30243 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319Ab2GPN1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 09:27:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="193386603"
Date: Mon, 16 Jul 2012 15:27:38 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Remove unneeded io_mutex from struct twl6040
Message-ID: <20120716132738.GE20652@sortiz-mobl>
References: <1341972394.25495.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341972394.25495.3.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Wed, Jul 11, 2012 at 10:06:34AM +0800, Axel Lin wrote:
> Current code has been converted to use regmap APIs, the io_mutex is not needed.
> Thus remove the io_mutex.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mfd/twl6040-core.c  |   23 +++--------------------
>  include/linux/mfd/twl6040.h |    1 -
>  2 files changed, 3 insertions(+), 21 deletions(-)
Patch applied thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
