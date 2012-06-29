Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab2F2OhM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 10:37:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:31513 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374Ab2F2OhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 10:37:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="186626166"
Date: Fri, 29 Jun 2012 16:48:19 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca
Subject: Re: [PATCH 06/14] mfd: Initialise the DB8500 PRCMU driver at
 core_initcall time
Message-ID: <20120629144819.GB22806@sortiz-mobl>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
 <1339428307-3850-7-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339428307-3850-7-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Mon, Jun 11, 2012 at 04:24:59PM +0100, Lee Jones wrote:
> Now the AB8500 has its own IRQ domain it needs to be initialised earlier
> in the boot sequence. As the AB8500 relies on the DB8500 PRCMU we need to
> reflect this change for the PRCMU driver too.
> 
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/db8500-prcmu.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
