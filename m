Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab2JBMNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 08:13:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:13755 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408Ab2JBMNg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 08:13:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,523,1344236400"; 
   d="scan'208";a="151474098"
Message-ID: <1349180009.13371.188.camel@smile>
Subject: Re: [PATCH 2/3] Add parenthesis to macros with complex values in
 trace.h
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: YAMANE Toshiaki <yamanetoshi@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Tue, 02 Oct 2012 15:13:29 +0300
In-Reply-To: <1349178868-29677-1-git-send-email-yamanetoshi@gmail.com>
References: <1349178827-29643-1-git-send-email-yamanetoshi@gmail.com>
	 <1349178868-29677-1-git-send-email-yamanetoshi@gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-02 at 20:54 +0900, YAMANE Toshiaki wrote: 
> fixed some checkpatch below error.
> -ERROR: Macros with complex values should be enclosed in parenthesis
> 
> Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
> ---
>  drivers/staging/rts_pstor/trace.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/rts_pstor/trace.h b/drivers/staging/rts_pstor/trace.h
> index 740999c..a34493c 100644
> --- a/drivers/staging/rts_pstor/trace.h
> +++ b/drivers/staging/rts_pstor/trace.h
> @@ -78,8 +78,8 @@ do {													\
>  	goto label; 											\
>  } while (0)
>  #else
> -#define TRACE_RET(chip, ret)	return ret
> -#define TRACE_GOTO(chip, label)	goto label
> +#define TRACE_RET(chip, ret)	return(ret)
> +#define TRACE_GOTO(chip, label)	goto(label)
>  #endif
In this specific case I think checkpatch.pl wants more than needed.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
