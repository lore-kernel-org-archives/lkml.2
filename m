Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990Ab1EZRIF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 13:08:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:57874 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757923Ab1EZRID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 13:08:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,275,1304319600"; 
   d="scan'208";a="5443114"
Date: Thu, 26 May 2011 19:07:56 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH -next] regulator: fix 88pm8607.c printk format warning
Message-ID: <20110526170756.GA20068@sortiz-mobl>
References: <20110518145412.f6cba4ef.sfr@canb.auug.org.au>
 <20110518100722.76bd6fb6.randy.dunlap@oracle.com>
 <20110518194311.GB5077@opensource.wolfsonmicro.com>
 <1305978663.3317.7.camel@odin>
 <20110526090522.5d8c684b.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526090522.5d8c684b.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On Thu, May 26, 2011 at 09:05:22AM -0700, Randy Dunlap wrote:
> On Sat, 21 May 2011 12:51:03 +0100 Liam Girdwood wrote:
> 
> > On Wed, 2011-05-18 at 12:43 -0700, Mark Brown wrote:
> > > On Wed, May 18, 2011 at 10:07:22AM -0700, Randy Dunlap wrote:
> > > > From: Randy Dunlap <randy.dunlap@oracle.com>
> > > > 
> > > > Fix printk format warning (seen on x86_64) and change to unsigned
> > > > output format:
> > > > 
> > > > drivers/regulator/88pm8607.c:417: warning: format '%d' expects type 'int', but argument 3 has type 'resource_size_t'
> > > 
> > > Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > > --
> > 
> > Samuel, this doesn't apply against regulator-next. Iirc, the patches
> > this is against went via mfd-next ? If, so any chance you could take
> > this ?
> > 
> > Thanks !
> > 
> > Liam  
> 
> Samuel,
> Do you need this patch resent to you?
I never got the patch. I'd appreciate if you could resend it to me, yes.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
