Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab1CKUoL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 15:44:11 -0500
Received: from mga01.intel.com ([192.55.52.88]:6939 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755226Ab1CKUoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 15:44:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,305,1297065600"; 
   d="scan'208";a="896395286"
Date: Fri, 11 Mar 2011 21:44:05 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Andres Salomon <dilinger@queued.net>, Sascha Hauer <kernel@pengutronix.de>,
        Amit Kucheria <amit.kucheria@canonical.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] ARM: mx51_efika: update platform data for new mfd
 changes
Message-ID: <20110311204405.GE20247@sortiz-mobl>
References: <20110304080653.3f2c3f19@debxo>
 <20110307085358.GM29521@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110307085358.GM29521@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

On Mon, Mar 07, 2011 at 09:53:58AM +0100, Sascha Hauer wrote:
> On Fri, Mar 04, 2011 at 08:06:53AM -0800, Andres Salomon wrote:
> > Note that this relies on stuff currently in mfd's next tree, but this
> > is also a newer driver.  I'm not sure which tree it should go through,
> > as it's a problem that shows up in next.
> 
> Please ping me again when the mfd tree is in Linus master. I see no
> other chance fixing this on my side other than removing regulator
> support for efika completely for now. So I guess you have to live with
> the compile breakage for some time.
It would probably make sense for me to carry this driver then. Sascha, would
you be ok with it ? If that's so, could you please point me at a git commit
from your tree ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
