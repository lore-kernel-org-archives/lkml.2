Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab0IJPNk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 11:13:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:47339 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754352Ab0IJPNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 11:13:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,346,1280732400"; 
   d="scan'208";a="323187698"
Date: Fri, 10 Sep 2010 17:13:59 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Felipe Balbi <felipe.balbi@nokia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] i2c: twl: add register defines for pm master module
Message-ID: <20100910151358.GH2561@sortiz-mobl>
References: <1282112377-1335-1-git-send-email-felipe.balbi@nokia.com>
 <1282112377-1335-2-git-send-email-felipe.balbi@nokia.com>
 <20100818071916.GF11947@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100818071916.GF11947@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Wed, Aug 18, 2010 at 10:19:16AM +0300, Felipe Balbi wrote:
> hi,
> 
> On Wed, Aug 18, 2010 at 08:19:34AM +0200, Balbi Felipe (Nokia-MS/Helsinki) wrote:
> >From: Felipe Balbi <felipe.balbi@nokia.com>
> >
> >Some modules already need to talk to at least PROTECT_KEY
> >register, while at that, add defines to the entire register
> >space.
> >
> >Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
> >---
> 
> here's updated patch with correct register space
All 4 patches applied, many thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
