Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab2GBOoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 10:44:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:44453 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155Ab2GBOoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 10:44:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="187524543"
Date: Mon, 2 Jul 2012 16:55:00 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Michael Hennerich <michael.hennerich@analog.com>
Subject: Re: [PATCH] mfd: adp5520: Guard PM methods with CONFIG_PM_SLEEP
Message-ID: <20120702145500.GL22065@sortiz-mobl>
References: <1341219232.5864.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341219232.5864.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Mon, Jul 02, 2012 at 04:53:52PM +0800, Axel Lin wrote:
> This fixes below build warnings:
>   CC      drivers/mfd/adp5520.o
> drivers/mfd/adp5520.c:324:12: warning: 'adp5520_suspend' defined but not used [-Wunused-function]
> drivers/mfd/adp5520.c:333:12: warning: 'adp5520_resume' defined but not used [-Wunused-function]
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mfd/adp5520.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
Thanks, patch applied as well.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
