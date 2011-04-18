Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab1DRI4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 04:56:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:52536 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708Ab1DRIzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 04:55:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,231,1301900400"; 
   d="scan'208";a="911009403"
Date: Mon, 18 Apr 2011 10:55:49 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Juergen Kilb <J.Kilb@phytec.de>
Cc: linux-arm-kernel@lists.infradead.org, dbrownell@users.sourceforge.net,
        balbi@ti.com, gregkh@suse.de, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fixed gpio polarity of gpio USB-phy reset.
Message-ID: <20110418085548.GB8593@sortiz-mobl>
References: <1302766303-1157-1-git-send-email-J.Kilb@phytec.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302766303-1157-1-git-send-email-J.Kilb@phytec.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Juergen,

On Thu, Apr 14, 2011 at 09:31:43AM +0200, Juergen Kilb wrote:
> With commit 19403165 a main part of ehci-omap.c moved to
> drivers/mfd/omap-usb-host.c created by commit 17cdd29d.
> Due to this reorganisation the polarity used to reset the
> external USB phy changed and USB host doesn't recognize
> any devices.
Patch applied to my for-linus branch, thanks a lot.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
