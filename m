Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762774Ab2ERKy1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:54:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:6968 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762427Ab2ERKyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:54:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="154385570"
Date: Fri, 18 May 2012 13:04:20 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
Subject: Re: linux-next: Tree for May 16 (mfd/mc13xxx)
Message-ID: <20120518110420.GM12015@sortiz-mobl>
References: <20120516201426.3a162ecd6adeb7132413f1b9@canb.auug.org.au>
 <4FB3CF4E.8000106@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB3CF4E.8000106@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On Wed, May 16, 2012 at 09:01:18AM -0700, Randy Dunlap wrote:
> On 05/16/2012 03:14 AM, Stephen Rothwell wrote:
> 
> > 
> > The mfd tree lost its build failure but gained another so I used the
> > version from next-20120511.
> 
> 
> drivers/mfd/mc13xxx-core.c:726:2: error: implicit declaration of function 'regmap_exit'
> 
> 
> Full randconfig file is attached.
> (REGMAP is not enabled.)
I just pushed a patch to fix this one.

Cheers,
Samuel

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
