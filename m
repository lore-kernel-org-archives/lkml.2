Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab2KWOVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 09:21:23 -0500
Received: from mga03.intel.com ([143.182.124.21]:45040 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227Ab2KWOVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 09:21:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,307,1352102400"; 
   d="scan'208";a="171762320"
Date: Fri, 23 Nov 2012 15:21:18 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] regulator: add a regulator driver for the AS3711
 PMIC
Message-ID: <20121123142118.GI12685@sortiz-mobl>
References: <Pine.LNX.4.64.1211221107520.28453@axis700.grange>
 <Pine.LNX.4.64.1211221110330.28453@axis700.grange>
 <20121123111515.GD12685@sortiz-mobl>
 <20121123114915.GG4529@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121123114915.GG4529@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2012 at 08:49:16PM +0900, Mark Brown wrote:
> On Fri, Nov 23, 2012 at 12:15:15PM +0100, Samuel Ortiz wrote:
> 
> > Mark, does that look ok with you ? There's a build dependency with patch #1,
> > so it would make sense for me to take it.
> 
> If there's a build dependency there's a problem - the Kconfig should
> prevent the driver being selected without the MFD.
It indeed does, sorry for the noise.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
