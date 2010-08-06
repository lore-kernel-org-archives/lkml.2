Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933889Ab0HFHJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 03:09:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57036 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933221Ab0HFHJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 03:09:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=HnvaoNExcmGt/aFxTtAAA1VdQfj+3fInWHlXBCjyQBo1kizcEOlyMsVEcPuGxcZmEG
         Ky2J+VL1wF224k+FkZB3+porySRxGe/9qQSwlx0ZrIH9UXoR65MmjkHsbRaBJaKzm/Tq
         DiVx1CnVnZoRyvFt4mk86D/zmnKk27EP5cJR8=
Date: Fri, 6 Aug 2010 09:07:50 +0200
From: Dan Carpenter <error27@gmail.com>
To: Julia Lawall <julia@diku.dk>
Cc: Eilon Greenstein <eilong@broadcom.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 32/42] drivers/net/bnx2x: Adjust confusing if
	indentation
Message-ID: <20100806070749.GP9031@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Julia Lawall <julia@diku.dk>,
	Eilon Greenstein <eilong@broadcom.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.1008052226210.31692@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1008052226210.31692@ask.diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 10:26:38PM +0200, Julia Lawall wrote:
> ---
> This patch doesn't change the semantics of the code.  But it might not be
> what is intended.
> 

I think there may have been some if statements which were removed before
the code was merged into the kernel?  Here is another one from that same
function.  Someone can roll this in with your patch.

regards,
dan carpenter

diff --git a/drivers/net/bnx2x/bnx2x_link.c b/drivers/net/bnx2x/bnx2x_link.c
index 0fa0991..ca0e435 100644
--- a/drivers/net/bnx2x/bnx2x_link.c
+++ b/drivers/net/bnx2x/bnx2x_link.c
@@ -1242,11 +1242,11 @@ static void bnx2x_set_autoneg(struct link_params *params,
 			MDIO_CL73_USERB0_CL73_BAM_CTRL1_BAM_NP_AFTER_BP_EN);
 
 		/* Advertise CL73 link speeds */
-			CL45_RD_OVER_CL22(bp, params->port,
-					      params->phy_addr,
-					      MDIO_REG_BANK_CL73_IEEEB1,
-					      MDIO_CL73_IEEEB1_AN_ADV2,
-					      &reg_val);
+		CL45_RD_OVER_CL22(bp, params->port,
+				      params->phy_addr,
+				      MDIO_REG_BANK_CL73_IEEEB1,
+				      MDIO_CL73_IEEEB1_AN_ADV2,
+				      &reg_val);
 		if (params->speed_cap_mask &
 		    PORT_HW_CFG_SPEED_CAPABILITY_D0_10G)
 			reg_val |= MDIO_CL73_IEEEB1_AN_ADV2_ADVR_10G_KX4;
