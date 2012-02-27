Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab2B0KKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 05:10:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:55799 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541Ab2B0KKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 05:10:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="112186919"
Date: Mon, 27 Feb 2012 11:17:58 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Benoit Cousson <b-cousson@ti.com>
Subject: Re: [PATCH 2/2] mfd: twl-core: Add IRQ_DOMAIN dependency
Message-ID: <20120227101758.GI27687@sortiz-mobl>
References: <1330102448-19172-1-git-send-email-grant.likely@secretlab.ca>
 <1330102448-19172-2-git-send-email-grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330102448-19172-2-git-send-email-grant.likely@secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant, Benoit,

On Fri, Feb 24, 2012 at 09:54:08AM -0700, Grant Likely wrote:
> From: Benoit Cousson <b-cousson@ti.com>
> 
> TWL4030 depends on IRQ_DOMAIN support, so this patch selects it in Kconfig.
> It used to be that CONFIG_IRQ_DOMAIN must only be selected by the architecture,
> but recent cleanups have fixed it so that it is safe to select from anywhere.
Applied to my for-next branch, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
