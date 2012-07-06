Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933047Ab2GFHEA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 03:04:00 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:43968 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224Ab2GFHD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 03:03:58 -0400
Date: Fri, 6 Jul 2012 10:03:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Miguel =?iso-8859-1?Q?G=F3mez?= <magomez@igalia.com>
Cc: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/19] Staging: xgifb: Fix coding style.
Message-ID: <20120706070306.GB29479@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 04:46:01PM +0200, Miguel Gómez wrote:
> diff --git a/drivers/staging/xgifb/vb_table.h b/drivers/staging/xgifb/vb_table.h
> index ca8c68d..e8467ca 100644
> --- a/drivers/staging/xgifb/vb_table.h
> +++ b/drivers/staging/xgifb/vb_table.h
> @@ -1838,9 +1838,9 @@ static struct XGI330_LCDDataTablStruct XGI_LCDDataTable[] = {
>  	{Panel_1024x768x75, 0x0019, 0x0001, 12}, /* XGI_ExtLCD1024x768x75Data */
>  	{Panel_1024x768x75, 0x0019, 0x0000, 13}, /* XGI_StLCD1024x768x75Data */
>  	{Panel_1024x768x75, 0x0018, 0x0010, 14}, /* XGI_CetLCD1024x768x75Data */
> -	{Panel_1280x1024x75, 0x0019, 0x0001, 15}, /* XGI_ExtLCD1280x1024x75Data*/
> -	{Panel_1280x1024x75, 0x0019, 0x0000, 16}, /* XGI_StLCD1280x1024x75Data */
> -	{Panel_1280x1024x75, 0x0018, 0x0010, 17}, /* XGI_CetLCD1280x1024x75Data*/
> +	{Panel_1280x1024x75, 0x0019, 0x0001, 15}, /*XGI_ExtLCD1280x1024x75Data*/
> +	{Panel_1280x1024x75, 0x0019, 0x0000, 16}, /*XGI_StLCD1280x1024x75Data */
> +	{Panel_1280x1024x75, 0x0018, 0x0010, 17}, /*XGI_CetLCD1280x1024x75Data*/

Don't do this...  :P  You did that above as well and I was going to
let it slide without commenting.  It's better to have an 82
character line instead of messing up the style.

regards,
dan carpenter
