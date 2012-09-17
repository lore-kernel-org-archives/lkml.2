Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059Ab2IQNbA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 09:31:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:35042 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319Ab2IQNa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 09:30:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,435,1344236400"; 
   d="scan'208";a="223015126"
Date: Mon, 17 Sep 2012 15:30:54 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Dong Aisheng <b29396@freescale.com>
Cc: Shawn Guo <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Zhao Richard-B20223 <B20223@freescale.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>
Subject: Re: [PATCH v6 0/4] add syscon driver based on regmap for general
 registers access
Message-ID: <20120917133054.GT3647@sortiz-mobl>
References: <1346813836-28736-1-git-send-email-b29396@freescale.com>
 <20120905055410.GZ2362@S2101-09.ap.freescale.net>
 <20120917101028.GA13226@shlinux2.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120917101028.GA13226@shlinux2.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dong,

On Mon, Sep 17, 2012 at 06:10:29PM +0800, Dong Aisheng wrote:
> Hi Samuel,
> 
> On Wed, Sep 05, 2012 at 01:54:12PM +0800, Shawn Guo wrote:
> > Hi Samuel,
> > 
> > The series needs to go via mfd or arm-soc tree as a whole.  In case
> > you want to take it through mfd tree, here is my ack.
> > 
> > Acked-by: Shawn Guo <shawn.guo@linaro.org>
> > 
> > Otherwise, I can take it via arm-soc tree with your ack.
> > 
> Ping...
All 4 patches applied to my for-next branch. Sorry for the delay.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
