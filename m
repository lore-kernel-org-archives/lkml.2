Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab2LQOKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 09:10:48 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:22821 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab2LQOKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 09:10:47 -0500
Date: Mon, 17 Dec 2012 17:08:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sebastian Wankerl <sisewank@cip.cs.fau.de>
Cc: linux-kernel@i4.informatik.uni-erlangen.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sebastian Wankerl 
	<sisewank@faui49man10.informatik.uni-erlangen.de>,
        Sebastian Ehrenfels <qi50dube@cip.cs.fau.de>
Subject: Re: [PATCH 2/3] wlan-ng/prism2mgmt.c: formated too long lines
Message-ID: <20121217140851.GR5083@mwanda>
References: <1355751483-7059-1-git-send-email-sisewank@cip.cs.fau.de>
 <1355751483-7059-2-git-send-email-sisewank@cip.cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355751483-7059-2-git-send-email-sisewank@cip.cs.fau.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 02:38:02PM +0100, Sebastian Wankerl wrote:
> From: Sebastian Wankerl <sisewank@faui49man10.informatik.uni-erlangen.de>
> 

We allow long lines for string literals actually.  Or you can break
it up.

> Signed-off-by: Sebastian Wankerl <sisewank@cip.cs.fau.de> 
> Signed-off-by: Sebastian Ehrenfels <qi50dube@cip.cs.fau.de>
> 
> ---
>  drivers/staging/wlan-ng/prism2mgmt.c |   20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/staging/wlan-ng/prism2mgmt.c b/drivers/staging/wlan-ng/prism2mgmt.c
> index 62b94b0..4b3db73 100644
> --- a/drivers/staging/wlan-ng/prism2mgmt.c
> +++ b/drivers/staging/wlan-ng/prism2mgmt.c
> @@ -1144,9 +1144,9 @@ int prism2mgmt_wlansniff(wlandevice_t *wlandev, void *msgp)
>  			/* Enable the port */
>  			result = hfa384x_drvr_enable(hw, 0);
>  			if (result) {
> -				pr_debug
> -				("failed to enable port to presniff setting, result=%d\n",
> -				     result);
> +				pr_debug(
> +					"failed to enable port to presniff setting,"
                                                                                   ^
Space needed.

You may as well put the string on the same line as the pr_debug().
It only costs you one char.

				pr_debug("failed to enable port for sniffing, "
					 "result = %d", result);

> +					"result=%d\n", result);
>  				goto failed;
>  			}

	[ snip ]

>  				/* Disable the port */
>  				result = hfa384x_drvr_disable(hw, 0);
>  				if (result) {
> -					pr_debug
> -					    ("failed to enable port for sniffing, result=%d\n",
> -					     result);
> +					pr_debug(
> +						"failed to enable port for "
                                                           ^^^^^^
Disable.

> +						"sniffing, result=%d\n",
> +						result);
>  					goto failed;
>  				}
>  			}

regards,
dan carpenter
