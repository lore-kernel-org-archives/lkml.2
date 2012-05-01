Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab2EAKjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 06:39:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:54364 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908Ab2EAKjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 06:39:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="94973782"
Date: Tue, 1 May 2012 12:39:49 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Marc Reilly <marc@cpdesign.com.au>
Cc: spi-devel-general@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: mc13xxx: add I2C support, V5
Message-ID: <20120501103949.GC20224@sortiz-mobl>
References: <1333262499-25871-1-git-send-email-marc@cpdesign.com.au>
 <201204170921.42027.marc@cpdesign.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201204170921.42027.marc@cpdesign.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

On Tue, Apr 17, 2012 at 09:21:41AM +1000, Marc Reilly wrote:
> Hi Samuel,
> 
> 
> On Sunday, April 01, 2012 04:41:35 PM Marc Reilly wrote:
> > This series (against mfd-2.6/for-next) changes the mc13xxx driver to use
> > regmap and adds I2C support.
> > It has a compile dependency on regmap/for-next, as the spi driver uses the
> > recently added pad_bits config field.
> 
> (bump).
> 
> Are these changes OK to go in?
All 4 patches applied to my for-next branch.
I had to manually apply patch #1, please verify that it's all good.
I added an Acked-by: Oskar Schirmer <oskar@scara.com> to patch #4. Please make
sure that you add the right tags to the corresponding patches in the future.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
