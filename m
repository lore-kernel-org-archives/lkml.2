Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631Ab1G2OsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 10:48:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab1G2OsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 10:48:07 -0400
Date: Fri, 29 Jul 2011 10:48:02 -0400
From: Dave Jones <davej@redhat.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH] cpufreq: Fix build of s3c64xx cpufreq driver for header
 change
Message-ID: <20110729144802.GB1422@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
	Kukjin Kim <kgene.kim@samsung.com>
References: <1311949618-919-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311949618-919-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 03:26:58PM +0100, Mark Brown wrote:
 > Some header change has removed an implicit include of module.h, breaking
 > the build due to the use of THIS_MODULE. Fix that.

is this dependant on the module.h changes that just got merged in -next
from Paul Gortmaker ?  If so, it should probably get merged as part of that set.

	Dave 

 > Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
 > ---
 >  drivers/cpufreq/s3c64xx-cpufreq.c |    1 +
 >  1 files changed, 1 insertions(+), 0 deletions(-)
 > 
 > diff --git a/drivers/cpufreq/s3c64xx-cpufreq.c b/drivers/cpufreq/s3c64xx-cpufreq.c
 > index b8d1d20..3475f65 100644
 > --- a/drivers/cpufreq/s3c64xx-cpufreq.c
 > +++ b/drivers/cpufreq/s3c64xx-cpufreq.c
 > @@ -15,6 +15,7 @@
 >  #include <linux/clk.h>
 >  #include <linux/err.h>
 >  #include <linux/regulator/consumer.h>
 > +#include <linux/module.h>
 >  
 >  static struct clk *armclk;
 >  static struct regulator *vddarm;
 > -- 
 > 1.7.5.4

