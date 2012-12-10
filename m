Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab2LJJqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 04:46:34 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:49885 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab2LJJqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 04:46:33 -0500
Date: Mon, 10 Dec 2012 12:46:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Przemo Firszt <przemo@firszt.eu>
Cc: Larry.Finger@lwfinger.net, florian.c.schilhabel@googlemail.com,
        greg@kroah.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] rtl8712: replace leading spaces with tab
Message-ID: <20121210094613.GR6568@mwanda>
References: <1355048110-10859-1-git-send-email-przemo@firszt.eu>
 <1355048110-10859-5-git-send-email-przemo@firszt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355048110-10859-5-git-send-email-przemo@firszt.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 09, 2012 at 10:15:10AM +0000, Przemo Firszt wrote:
> Replace leading spaces with tab
> 
> Signed-off-by: Przemo Firszt <przemo@firszt.eu>
> ---
>  drivers/staging/rtl8712/rtl871x_ioctl_linux.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> index b131b61..b4629c3 100644
> --- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> +++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> @@ -510,7 +510,7 @@ exit:
>  }
>  
>  static int r871x_set_wpa_ie(struct _adapter *padapter, char *pie,
> -			    unsigned short ielen)
> +				unsigned short ielen)

The original version is better because it lines up correctly.

Checkpatch doesn't complain for me so I'm not sure what the story is
here.

regards,
dan carpenter

