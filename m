Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab0JMIUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 04:20:36 -0400
Received: from mga14.intel.com ([143.182.124.37]:14718 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123Ab0JMIUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 04:20:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,324,1283756400"; 
   d="scan'208";a="335501889"
Date: Wed, 13 Oct 2010 10:20:06 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mike Rapoport <mike@compulab.co.il>
Cc: Andrew Chew <AChew@nvidia.com>, "axel.lin@gmail.com" <axel.lin@gmail.com>,
        Gary King <GKing@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Greg KH'" <greg@kroah.com>
Subject: Re: [PATCH 1/1] mfd: Add TPS658621C device ID
Message-ID: <20101013082005.GA4035@sortiz-mobl>
References: <643E69AA4436674C8F39DCC2C05F763816BB82897A@HQMAIL03.nvidia.com>
 <4CB54BD0.8080701@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CB54BD0.8080701@compulab.co.il>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Wed, Oct 13, 2010 at 08:04:00AM +0200, Mike Rapoport wrote:
> Samuel,
> 
> Can you please queue this?
Yes, I will.

Cheers,
Samuel.

> 
> Andrew Chew wrote:
> >Sending again.  Can someone review for commit?
> >
> >This is a really simple change that adds a new valid device ID for the existing tps6586x PMU driver.
> >
> >The interface for this device should be identical to that of the
> >TPS658521A.
> >
> >Signed-off-by: Andrew Chew <achew@nvidia.com>
> 
> Acked-by: Mike Rapoport <mike@compulab.co.il>
> 
> >---
> > drivers/mfd/tps6586x.c |    4 +++-
> > 1 files changed, 3 insertions(+), 1 deletions(-)
> >
> >diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
> >index 117eb7c..b4931ab 100644
> >--- a/drivers/mfd/tps6586x.c
> >+++ b/drivers/mfd/tps6586x.c
> >@@ -47,6 +47,7 @@
> > /* device id */
> > #define TPS6586X_VERSIONCRC	0xcd
> > #define TPS658621A_VERSIONCRC	0x15
> >+#define TPS658621C_VERSIONCRC	0x2c
> > struct tps6586x_irq_data {
> > 	u8	mask_reg;
> >@@ -497,7 +498,8 @@ static int __devinit tps6586x_i2c_probe(struct i2c_client *client,
> > 		return -EIO;
> > 	}
> >-	if (ret != TPS658621A_VERSIONCRC) {
> >+	if ((ret != TPS658621A_VERSIONCRC) &&
> >+	    (ret != TPS658621C_VERSIONCRC)) {
> > 		dev_err(&client->dev, "Unsupported chip ID: %x\n", ret);
> > 		return -ENODEV;
> > 	}
> 
> 
> -- 
> Sincerely yours,
> Mike.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
