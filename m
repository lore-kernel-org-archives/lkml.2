Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab2B0Obt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 09:31:49 -0500
Received: from mga09.intel.com ([134.134.136.24]:36399 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180Ab2B0Obs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 09:31:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="112245030"
Date: Mon, 27 Feb 2012 15:38:13 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Nishanth Menon <nm@ti.com>
Cc: linux-omap <linux-omap@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MFD: TWL 6030: make twl6030_irq_set_wake static
Message-ID: <20120227143813.GQ27687@sortiz-mobl>
References: <1329962639-29800-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329962639-29800-1-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nishan,

On Wed, Feb 22, 2012 at 08:03:59PM -0600, Nishanth Menon wrote:
> twl6030_irq_set_wake is not used anywhere else in the kernel
> except as irq_chip.irq_set_wake. No reason for it to be exported.
> 
> Also fixes build warning:
> drivers/mfd/twl6030-irq.c:230:5: warning: symbol 'twl6030_irq_set_wake' was not declared. Should it be static?
> 
Applied as well, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
