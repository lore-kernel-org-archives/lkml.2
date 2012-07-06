Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933070Ab2GFK2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:28:11 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:21197 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932928Ab2GFK2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:28:08 -0400
Date: Fri, 6 Jul 2012 13:27:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Miguel =?iso-8859-1?Q?G=F3mez?= <magomez@igalia.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, arnaud.patard@rtp-net.org,
        aaro.koskinen@iki.fi
Subject: Re: [PATCH 15/19] Staging: xgifb: Rework conditions in
 XGI_SetLockRegs().
Message-ID: <20120706102718.GI4462@mwanda>
References: <cover.1341498465.git.magomez@igalia.com>
 <59ae53c03975f8e81587077aa8b0221b356896b9.1341498466.git.magomez@igalia.com>
 <20120706065113.GG4462@mwanda>
 <4FF6AA0F.8090400@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FF6AA0F.8090400@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 11:04:15AM +0200, Miguel Gómez wrote:
> >On Thu, Jul 05, 2012 at 04:45:58PM +0200, Miguel Gómez wrote:
> >>Rework some conditions to reduce indentation and fix style warnings.
> >>
> >>Signed-off-by: Miguel Gómez <magomez@igalia.com>
> >>---
> >>  drivers/staging/xgifb/vb_setmode.c |   29 ++++++++++++-----------------
> >>  1 file changed, 12 insertions(+), 17 deletions(-)
> >>
> >>diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
> >>index a7ba99f..b439f59 100644
> >>--- a/drivers/staging/xgifb/vb_setmode.c
> >>+++ b/drivers/staging/xgifb/vb_setmode.c
> >>@@ -4039,23 +4039,18 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
> >>  	}
> >>
> >>  	if (pVBInfo->VBInfo & SetCRT2ToHiVision) {
> >>-		if (pVBInfo->VBType & VB_SIS301LV) {
> >>-			if (pVBInfo->TVInfo & TVSetHiVision) {
> >>-				tempbx -= 10;
> >
> >We drop this -= 10 in the final.  It seems accidental.
> 
> Nope, it's done on purpose.

Ah.  You are right.  Sorry for the noise.

regards,
dan carpenter

