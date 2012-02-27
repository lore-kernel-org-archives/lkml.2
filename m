Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab2B0O1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 09:27:22 -0500
Received: from mga11.intel.com ([192.55.52.93]:49158 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453Ab2B0O1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 09:27:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="129859312"
Date: Mon, 27 Feb 2012 15:34:44 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        David Dajun Chen <dchen@diasemi.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] mfd: Remove unused io_lock mutex from da9052
Message-ID: <20120227143444.GO27687@sortiz-mobl>
References: <1329882220.4193.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329882220.4193.0.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Wed, Feb 22, 2012 at 11:43:40AM +0800, Axel Lin wrote:
> da9052 has been converted to use regmap API, so we can remove the unused
> io_lock mutex.
Thanks, patch applied.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
