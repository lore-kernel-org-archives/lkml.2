Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab2EKN1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 09:27:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:64198 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470Ab2EKN1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 09:27:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="142773577"
Date: Fri, 11 May 2012 15:36:52 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] mfd: lm3533-core: Fix calling regmap_update_bits() with
 mask and val arguments swapped
Message-ID: <20120511133652.GM1214@sortiz-mobl>
References: <1336664102.15392.1.camel@phoenix>
 <20120510154925.GB29437@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120510154925.GB29437@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johan, Axel,

On Thu, May 10, 2012 at 05:49:25PM +0200, Johan Hovold wrote:
> On Thu, May 10, 2012 at 11:35:02PM +0800, Axel Lin wrote:
> > Current code calls regmap_update_bits() with mask and val arguments swapped.
> > Fix it.
> > 
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Signed-off-by: Johan Hovold <jhovold@gmail.com>
Rather Acked-by.
I applied this patch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
