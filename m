Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843Ab2JBMML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 08:12:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:57325 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174Ab2JBMMJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 08:12:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,523,1344236400"; 
   d="scan'208";a="229498790"
Message-ID: <1349179923.13371.186.camel@smile>
Subject: Re: [PATCH 1/3] Fix trailing whitespace in trace.h
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: YAMANE Toshiaki <yamanetoshi@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Tue, 02 Oct 2012 15:12:03 +0300
In-Reply-To: <1349178827-29643-1-git-send-email-yamanetoshi@gmail.com>
References: <1349178827-29643-1-git-send-email-yamanetoshi@gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-02 at 20:53 +0900, YAMANE Toshiaki wrote: 
> fixed below checkpatch error.
> 
> -ERROR: trailing whitespace
> 
> Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
> ---
>  drivers/staging/rts_pstor/trace.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/rts_pstor/trace.h b/drivers/staging/rts_pstor/trace.h
> index cf60a1b..740999c 100644
> --- a/drivers/staging/rts_pstor/trace.h
> +++ b/drivers/staging/rts_pstor/trace.h
> @@ -39,7 +39,7 @@ static inline char *filename(char *path)
>  	while (*ptr != '\0') {
>  		if ((*ptr == '\\') || (*ptr == '/'))
>  			path = ptr + 1;
> -		
> +
>  		ptr++;
>  	}

For me it seems total filename() function could be squeezed to just strrchr(path, '/') + 1;
Moreover there is already basename() in the lib/dynamic_debug.c you
could rename, export and reuse.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
