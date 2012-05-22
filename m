Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760375Ab2EVT6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 15:58:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:62875 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760300Ab2EVT6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 15:58:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="103006754"
Date: Tue, 22 May 2012 22:08:35 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Graeme Gregory <gg@slimlogic.co.uk>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] mfd: Add terminating entry for i2c_device_id table
Message-ID: <20120522200835.GB10210@sortiz-mobl>
References: <1337614402.15342.1.camel@phoenix>
 <20120522101106.GG21999@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120522101106.GG21999@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, May 22, 2012 at 11:11:07AM +0100, Mark Brown wrote:
> On Mon, May 21, 2012 at 11:33:22PM +0800, Axel Lin wrote:
> > The i2c_device_id table is supposed to be zero-terminated.
> > 
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Samuel, Linus already pulled the regmap tree so this should probably go
> via MFD as a bug fix?  Might have to wait to after -rc1 to avoid you
> having to rebase though...
Yes, I'm queueing this one for my first post merge window pull request.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
