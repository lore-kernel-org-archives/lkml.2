Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab2BTTss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 14:48:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:37737 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059Ab2BTTsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 14:48:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="112503799"
Date: Mon, 20 Feb 2012 20:55:54 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dmitry Torokhov <dtor@mail.ru>,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 7/7] MFD: TWL6040: Add regulator support for VIO, V2V1
 supplies
Message-ID: <20120220195554.GQ5387@sortiz-mobl>
References: <1328619678-26080-1-git-send-email-peter.ujfalusi@ti.com>
 <1328619678-26080-8-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328619678-26080-8-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Tue, Feb 07, 2012 at 03:01:18PM +0200, Peter Ujfalusi wrote:
> twl6040 has three power supply source:
> VBAT needs to be connected to VBAT, VIO, and V2V1.
> Add regulator support for the VIO, V2V1 supplies.
> Initially handle the two supply together with bulk commands.
I applied this one.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
