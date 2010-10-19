Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026Ab0JSJKR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 05:10:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:53484 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754883Ab0JSJKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 05:10:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,349,1283756400"; 
   d="scan'208";a="848586936"
Date: Tue, 19 Oct 2010 11:10:07 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mike Rapoport <mike@compulab.co.il>
Cc: achew@nvidia.com, axel.lin@gmail.com, gking@nvidia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mfd: Add TPS658621C device ID
Message-ID: <20101019091006.GB2736@sortiz-mobl>
References: <1286317946-11170-1-git-send-email-achew@nvidia.com>
 <4CAC1347.3000301@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CAC1347.3000301@compulab.co.il>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike, Andrew,

On Wed, Oct 06, 2010 at 08:12:23AM +0200, Mike Rapoport wrote:
> Hi Samuel,
> 
> Can you please queue this?
> 
Patch applied now, many thanks.

Cheers,
Samuel.


> achew@nvidia.com wrote:
> >From: Andrew Chew <achew@nvidia.com>
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
