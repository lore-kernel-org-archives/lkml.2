Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab2JAKrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 06:47:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:41143 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311Ab2JAKrl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 06:47:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,515,1344236400"; 
   d="scan'208";a="228999448"
Message-ID: <1349088437.13371.167.camel@smile>
Subject: Re: [PATCHv3 1/7] dmaengine: dw_dmac: use helper macro
 module_platform_driver()
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: balbi@ti.com
Cc: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Date: Mon, 01 Oct 2012 13:47:17 +0300
In-Reply-To: <20120927074039.GH12592@arwen.pp.htv.fi>
References: <1348731121-2515-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1348731121-2515-2-git-send-email-andriy.shevchenko@linux.intel.com>
	 <20120927074039.GH12592@arwen.pp.htv.fi>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-27 at 10:40 +0300, Felipe Balbi wrote: 
> On Thu, Sep 27, 2012 at 10:31:55AM +0300, Andy Shevchenko wrote:
> > From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > 
> 
> commit log would be great.
Will do.

> >  static struct platform_driver dw_driver = {
> > +	.probe		= dw_probe,
> 
> probe's in __init section. This is wrong. You need to change probe
> __devinit.
Have you checked this one
0272e93f364eac1a30f2831adcaca3dd633d5f14

Or might be I missed something?


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
