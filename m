Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab0IEGfO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 02:35:14 -0400
Received: from cantor.suse.de ([195.135.220.2]:56692 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266Ab0IEGfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 02:35:11 -0400
Date: Sat, 4 Sep 2010 23:24:26 -0700
From: Greg KH <gregkh@suse.de>
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Cc: Bill Pemberton <wfp5p@virginia.edu>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Arnaud Patard <apatard@mandriva.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, Huang Weiyi <weiyi.huang@gmail.com>
Subject: Re: [PATCH 2/4] staging: xgifb: Add compilation conditionals
Message-ID: <20100905062426.GB18329@suse.de>
References: <1283641668.9641.5.camel@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283641668.9641.5.camel@lenovo>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 04, 2010 at 07:07:48PM -0400, Javier Martinez Canillas wrote:
> 
> Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
> ---
>  drivers/staging/xgifb/XGI_main.h    |    2 ++
>  drivers/staging/xgifb/XGI_main_26.c |    6 ++++++
>  2 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/xgifb/XGI_main.h b/drivers/staging/xgifb/XGI_main.h
> index 72448e8..93837f3 100644
> --- a/drivers/staging/xgifb/XGI_main.h
> +++ b/drivers/staging/xgifb/XGI_main.h
> @@ -345,7 +345,9 @@ static int XGIfb_userom = 0;
>  static int XGIfb_registered;
>  static int XGIfb_tvmode = 0;
>  static int XGIfb_mem = 0;
> +#ifndef MODULE
>  static int XGIfb_pdc = 0;
> +#endif

Ick, no, don't add conditionals, fix the code to not need such nonsense.

thanks,

greg k-h
