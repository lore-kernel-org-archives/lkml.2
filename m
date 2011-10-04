Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab1JDK51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 06:57:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:19907 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755895Ab1JDK50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 06:57:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,484,1312182000"; 
   d="scan'208";a="70097953"
Date: Tue, 4 Oct 2011 13:00:26 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Keshava Munegowda <keshava_mgowda@ti.com>
Subject: Re: [PATCH 18/30] omap-usb: automatically select MFD_OMAP_USB_HOST
Message-ID: <20111004110026.GZ4118@sortiz-mobl>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
 <1317566760-25681-19-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317566760-25681-19-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Sun, Oct 02, 2011 at 04:45:48PM +0200, Arnd Bergmann wrote:
> The ehci-omap and ohci-omap3 drivers both depend on the
> omap-usb-host MFD support driver. By default, this is
> automatically turned on, but it is possible to disable
> the driver, which results in a link error.
I don't see the Kconfig entry for e.g. the ohci-omap3 driver, but shouldn't
the dependency be handled there ?
If ohci-omap3 depends on omap-usb-host, then we should not be able to disable
the latter while the former is selected.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
