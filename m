Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab0HIJo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 05:44:27 -0400
Received: from mga14.intel.com ([143.182.124.37]:17905 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755969Ab0HIJo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 05:44:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,341,1278313200"; 
   d="scan'208";a="309721924"
Date: Mon, 9 Aug 2010 11:44:30 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 1/4] mfd: max8998 - fix incorrect kfree(i2c) in
 i2c_driver probe callback handler
Message-ID: <20100809094429.GC2513@sortiz-mobl>
References: <1281336496.18804.2.camel@mola>
 <20100809091530.GB2513@sortiz-mobl>
 <1281346572.3035.5.camel@odin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281346572.3035.5.camel@odin>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 09, 2010 at 10:36:12AM +0100, Liam Girdwood wrote:
> On Mon, 2010-08-09 at 11:15 +0200, Samuel Ortiz wrote:
> > Hi Axel,
> > 
> > On Mon, Aug 09, 2010 at 02:48:16PM +0800, Axel Lin wrote:
> > > The i2c_client received in probe() should not be kfree()'d.
> > This should go through Liam's tree, I'm  CC'ing him to this thread.
> 
> Thanks, I assume I have you Ack too ?
Yup, sorry about that:
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

 
> Thanks
> 
> Liam
> -- 
> Freelance Developer, SlimLogic Ltd
> ASoC and Voltage Regulator Maintainer.
> http://www.slimlogic.co.uk
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
