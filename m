Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab1EILZ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 07:25:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:3725 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245Ab1EILZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 07:25:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,340,1301900400"; 
   d="scan'208";a="744402178"
Date: Mon, 9 May 2011 13:25:56 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Paul Parsons <lost.distance@yahoo.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [PATCH 06/19] mfd: Pass htc-pasic3 led platform data through
 the cell platform_data
Message-ID: <20110509112555.GD8071@sortiz-mobl>
References: <1304901131-7104-7-git-send-email-sameo@linux.intel.com>
 <185596.62393.qm@web29004.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <185596.62393.qm@web29004.mail.ird.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Mon, May 09, 2011 at 11:20:16AM +0100, Paul Parsons wrote:
> Hi Samuel,
> 
> I presume an earlier post called "mfd: Remove mfd_data" provided the patch for struct mfd_cell. If so would you please forward it to the list since I have no visibility of the change. Perhaps linux-kernel bounced the original post?
> 
I just realized that it did, yes. Maybe the Cc list was too long.
Anyway, I reposted it to lkml only:
http://lkml.org/lkml/2011/5/9/132

And http://lkml.org/lkml/2011/5/9/131 for the cover letter.

Cheers,
Samuel.


> Regards,
> Paul
> 
> --- On Mon, 9/5/11, Samuel Ortiz <sameo@linux.intel.com> wrote:
> 
> > diff --git a/drivers/mfd/htc-pasic3.c
> > b/drivers/mfd/htc-pasic3.c
> > index 95a4ff4..2808bd1 100644
> > --- a/drivers/mfd/htc-pasic3.c
> > +++ b/drivers/mfd/htc-pasic3.c
> > @@ -173,6 +173,8 @@ static int __init pasic3_probe(struct
> > platform_device *pdev)
> >      }
> >  
> >      if (pdata &&
> > pdata->led_pdata) {
> > +       
> > led_cell.platform_data = pdata->led_pdata;
> > +        led_cell.pdata_size
> > = sizeof(struct pasic3_leds_machinfo);
> >          ret =
> > mfd_add_devices(&pdev->dev, pdev->id,
> > &led_cell, 1, r, 0);
> >          if (ret < 0)
> >             
> > dev_warn(dev, "failed to register LED device\n");

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
