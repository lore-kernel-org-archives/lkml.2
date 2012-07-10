Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab2GJIuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 04:50:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:10540 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754226Ab2GJIuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 04:50:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="163686587"
Date: Tue, 10 Jul 2012 11:01:49 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Qiao Zhou <zhouqiao@marvell.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Export pm80x_regmap_config
Message-ID: <20120710090149.GS15345@sortiz-mobl>
References: <1341845061.8153.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341845061.8153.2.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Mon, Jul 09, 2012 at 10:44:21PM +0800, Axel Lin wrote:
> This fixes below build error when CONFIG_MFD_88PM800=m.
> 
> ERROR: "pm80x_regmap_config" [drivers/mfd/88pm800.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mfd/88pm80x.c |    1 +
>  1 file changed, 1 insertion(+)
Applied as well, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
