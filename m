Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab2GFGwE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 02:52:04 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:41566 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab2GFGwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 02:52:01 -0400
Date: Fri, 6 Jul 2012 09:51:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Miguel =?iso-8859-1?Q?G=F3mez?= <magomez@igalia.com>
Cc: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/19] Staging: xgifb: Rework conditions in
 XGI_SetLockRegs().
Message-ID: <20120706065113.GG4462@mwanda>
References: <cover.1341498465.git.magomez@igalia.com>
 <59ae53c03975f8e81587077aa8b0221b356896b9.1341498466.git.magomez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <59ae53c03975f8e81587077aa8b0221b356896b9.1341498466.git.magomez@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 04:45:58PM +0200, Miguel Gómez wrote:
> Rework some conditions to reduce indentation and fix style warnings.
> 
> Signed-off-by: Miguel Gómez <magomez@igalia.com>
> ---
>  drivers/staging/xgifb/vb_setmode.c |   29 ++++++++++++-----------------
>  1 file changed, 12 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
> index a7ba99f..b439f59 100644
> --- a/drivers/staging/xgifb/vb_setmode.c
> +++ b/drivers/staging/xgifb/vb_setmode.c
> @@ -4039,23 +4039,18 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
>  	}
>  
>  	if (pVBInfo->VBInfo & SetCRT2ToHiVision) {
> -		if (pVBInfo->VBType & VB_SIS301LV) {
> -			if (pVBInfo->TVInfo & TVSetHiVision) {
> -				tempbx -= 10;

We drop this -= 10 in the final.  It seems accidental.

regards,
dan carpenter


