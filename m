Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab2LNAy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 19:54:56 -0500
Received: from mga14.intel.com ([143.182.124.37]:65133 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444Ab2LNAyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 19:54:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,276,1355126400"; 
   d="scan'208";a="180697001"
Date: Fri, 14 Dec 2012 01:54:50 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Tony Lindgren <tony@atomide.com>
Cc: balbi@ti.com, paul@pwsan.com, keshava_mgowda@ti.com, sshtylyov@mvista.com,
        bjorn@mork.no, linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Roger Quadros <rogerq@ti.com>
Subject: Re: [PATCH v4 01/23] mfd: omap-usb-host: get rid of cpu_is_omap..()
 macros
Message-ID: <20121214005450.GO26699@sortiz-mobl>
References: <1355134833-5199-1-git-send-email-rogerq@ti.com>
 <1355134833-5199-2-git-send-email-rogerq@ti.com>
 <20121213214949.GH4989@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121213214949.GH4989@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Thu, Dec 13, 2012 at 01:49:49PM -0800, Tony Lindgren wrote:
> Hi Samuel,
> 
> * Roger Quadros <rogerq@ti.com> [121210 02:23]:
> > Instead of using cpu_is_omap..() macros in the device driver we
> > rely on information provided in the platform data.
> > 
> > The only information we need is whether the USB Host module has
> > a single ULPI bypass control bit for all ports or individual bypass
> > control bits for each port. OMAP3 REV2.1 and earlier have the former.
> 
> I'd like to apply this patch as a fix so I can finally nuke plat/cpu.h
> for omaps by -rc1 before more drivers start using it again.
> 
> That is assuming nobody else is planning on merging this series for
> v3.8 presumably. 
This should go into 3.9, yes.


> Want to ack this one?
Looks fine to me:
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
