Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760715Ab2IGO32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 10:29:28 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:35816 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482Ab2IGO30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 10:29:26 -0400
Date: Fri, 7 Sep 2012 09:29:18 -0500
From: scameron@beardog.cce.hp.com
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Fengguang Wu <wfg@linux.intel.com>, Mike Miller <mike.miller@hp.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH -mm] cciss: select CONFIG_CHECK_SIGNATURE
Message-ID: <20120907142918.GM3430@beardog.cce.hp.com>
References: <1347026211-10557-1-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347026211-10557-1-git-send-email-akinobu.mita@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 10:56:51PM +0900, Akinobu Mita wrote:
> The patch cciss-use-check_signature.patch in -mm tree introduced
> a build error:
> 
> drivers/built-in.o: In function `CISS_signature_present':
> drivers/block/cciss.c:4270: undefined reference to `check_signature'
> 
> Add missing CONFIG_CHECK_SIGNATURE to fix this issue.
> 

Ack.  

Same thing that was done for hpsa.

-- steve

> Reported-by: Fengguang Wu <wfg@linux.intel.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Fengguang Wu <wfg@linux.intel.com>
> Cc: Mike Miller <mike.miller@hp.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
> ---
>  drivers/block/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
> index f529407..f7de322 100644
> --- a/drivers/block/Kconfig
> +++ b/drivers/block/Kconfig
> @@ -131,6 +131,7 @@ config BLK_CPQ_DA
>  config BLK_CPQ_CISS_DA
>  	tristate "Compaq Smart Array 5xxx support"
>  	depends on PCI
> +	select CHECK_SIGNATURE
>  	help
>  	  This is the driver for Compaq Smart Array 5xxx controllers.
>  	  Everyone using these boards should say Y here.
> -- 
> 1.7.11.4


