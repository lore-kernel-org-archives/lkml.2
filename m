Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab1GFTGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 15:06:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:51079 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755486Ab1GFTGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 15:06:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,488,1304319600"; 
   d="scan'208";a="27011034"
Date: Wed, 6 Jul 2011 21:07:21 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Liam Girdwood <lrg@kernel.org>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] regulator/tps65912: storing error codes in u8
Message-ID: <20110706190721.GB30759@sortiz-mobl>
References: <20110623055715.GM14591@shale.localdomain>
 <1309795618.3272.9.camel@odin>
 <20110706183208.GK3021@sortiz-mobl>
 <20110706185718.GJ18655@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110706185718.GJ18655@shale.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On Wed, Jul 06, 2011 at 09:57:18PM +0300, Dan Carpenter wrote:
> get_ctrl_reg() returns -EINVAL so the error handling won't work here
> if reg is a u8.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
Thanks, patch applied.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
