Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab2JBMWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 08:22:14 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:36220 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab2JBMWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 08:22:13 -0400
Date: Tue, 2 Oct 2012 15:21:57 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: YAMANE Toshiaki <yamanetoshi@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Add parenthesis to macros with complex values in
 trace.h
Message-ID: <20121002122157.GU4587@mwanda>
References: <1349178827-29643-1-git-send-email-yamanetoshi@gmail.com>
 <1349178868-29677-1-git-send-email-yamanetoshi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349178868-29677-1-git-send-email-yamanetoshi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 08:54:28PM +0900, YAMANE Toshiaki wrote:
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

This will cause a compile error.

There is no need to do this, checkpatch.pl is wrong here.

regards,
dan carpenter

