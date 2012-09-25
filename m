Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab2IYInn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 04:43:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:35953 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478Ab2IYInk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 04:43:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,479,1344236400"; 
   d="scan'208";a="212538625"
Date: Tue, 25 Sep 2012 10:43:30 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias Kaehlcke <matthias@kaehlcke.net>
Subject: Re: linux-next: build failure after merge of the mfd tree
Message-ID: <20120925084330.GJ28670@sortiz-mobl>
References: <20120925134735.067e4f119bd71099df30724f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120925134735.067e4f119bd71099df30724f@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Tue, Sep 25, 2012 at 01:47:35PM +1000, Stephen Rothwell wrote:
> Hi Samuel,
> 
> After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> FATAL: modpost: GPL-incompatible module tps65217_bl.ko uses GPL-only symbol 'platform_driver_unregister'
> 
> Caused by commit dbc14ec43af2 ("backlight: Add TPS65217 WLED driver").
> 
> I have used the mfd tree from next-20120924 for today.
Thanks for the heads up, it's all fixed now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
