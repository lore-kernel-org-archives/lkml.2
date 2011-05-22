Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab1EVWPI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 18:15:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:39797 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795Ab1EVWPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 18:15:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,253,1304319600"; 
   d="scan'208";a="5615194"
Date: Mon, 23 May 2011 00:15:00 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Paul Parsons <lost.distance@yahoo.com>
Cc: linux-kernel@vger.kernel.org, philipp.zabel@gmail.com, mad_soft@inbox.ru
Subject: Re: [PATCH] mfd: Add ASIC3 PCMCIA/CF support
Message-ID: <20110522221459.GQ18610@sortiz-mobl>
References: <E1QNR1E-0003gV-IK@outmx04.plus.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1QNR1E-0003gV-IK@outmx04.plus.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Fri, May 20, 2011 at 02:49:35PM +0000, Paul Parsons wrote:
> Add PCMCIA/CF support for the HTC ASIC3. Underlying support is provided by the mfd/asic3 and pcmcia/pxa2xx-pcmcia drivers. An example configuration is provided by the pxa/hx4700 platform.
> 
Why is this driver linked to the pxa2 pcmcia driver ? Can't we make it just
asic3 specific and enable it from the board asic3 platform data ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
