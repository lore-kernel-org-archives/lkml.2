Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab1JOBLU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 21:11:20 -0400
Received: from mga14.intel.com ([143.182.124.37]:17065 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369Ab1JOBLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 21:11:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,349,1315206000"; 
   d="scan'208";a="62797049"
Date: Sat, 15 Oct 2011 03:14:37 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH v14] mfd: omap: usb: Runtime PM support (fwd)
Message-ID: <20111015011437.GC10229@sortiz-mobl>
References: <alpine.DEB.2.00.1110131810250.24155@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1110131810250.24155@utopia.booyaka.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Thu, Oct 13, 2011 at 06:11:26PM -0600, Paul Walmsley wrote:
> 
> Hi Samuel,
> 
> Care to ack this patch?  If so, we'll merge this series through the OMAP 
> tree.
> 
> 
> - Paul
> 
> ---------- Forwarded message ----------
> Date: Tue, 11 Oct 2011 13:23:29 +0530
> From: Keshava Munegowda <keshava_mgowda@ti.com>
> To: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
>     linux-kernel@vger.kernel.org, balbi@ti.com, khilman@ti.com,
>     b-cousson@ti.com, paul@pwsan.com
> Cc: Keshava Munegowda <keshava_mgowda@ti.com>, gadiyar@ti.com,
>     sameo@linux.intel.com, parthab@india.ti.com, tony@atomide.com,
>     johnstul@us.ibm.com, vishwanath.bs@ti.com,
>     Keshava Munegowda <Keshava_mgowda@ti.com>
> Subject: [PATCH v14] mfd: omap: usb: Runtime PM support
> 
> From: Keshava Munegowda <Keshava_mgowda@ti.com>
> 
> The usbhs core driver does not enable/disable the interface and
> functional clocks directly, These clocks are handled by runtime pm,
> hence instead of the clock enable/disable, the runtime pm APIS are
> used. however,the optional clocks and port clocks are handled by
> the usbhs core.
> 
> Dependency:
> This patch is dependent on this series:
> [PATCH 0/5 v13 or latest version] omap: usb: host: Runtime PM preparation 
> for EHCI and OHCI drivers.
> 
> Validation performed:
> The global suspend/resume of EHCI and OHCI is validated on 
> OMAP3430 sdp board with this patch combined with the series:
> [PATCH 0/5 v13 or latest version] omap: usb: host: Runtime PM preparation 
> for EHCI and OHCI drivers. 
> 
> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
> Reviewed-by: Kevin Hilman <khilman@ti.com>
> Reviewed-by: Partha Basak <parthab@india.ti.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
