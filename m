Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab0JSP2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 11:28:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:58144 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920Ab0JSP2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 11:28:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,350,1283756400"; 
   d="scan'208";a="848704106"
Date: Tue, 19 Oct 2010 17:27:57 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/2] mfd: Factor out WM831x I2C I/O from the core driver
Message-ID: <20101019152746.GV2736@sortiz-mobl>
References: <1286573003-13889-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20101019111553.GO2736@sortiz-mobl>
 <20101019151415.GA2677@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101019151415.GA2677@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 08:14:16AM -0700, Mark Brown wrote:
> On Tue, Oct 19, 2010 at 01:15:54PM +0200, Samuel Ortiz wrote:
> 
> > I think we should select MFD_WM831X here as well otherwise there's nothing
> > preventing us from building the I2C or the SPI part without the core one. And
> > that leads to a build breakage.
> 
> I agree, I'll try to send a followup out unless you update the patch
> before I get to it.
I'll update the patch.

Cheers,
Samuel.


-- 
Intel Open Source Technology Centre
http://oss.intel.com/
