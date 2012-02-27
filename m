Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab2B0Kdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 05:33:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:7476 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030Ab2B0Kdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 05:33:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="112191140"
Date: Mon, 27 Feb 2012 11:39:58 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Benoit Cousson <b-cousson@ti.com>
Subject: Re: [PATCH] devicetree: Add empty of_platform_populate() for
 !CONFIG_OF_ADDRESS (sparc)
Message-ID: <20120227103958.GJ27687@sortiz-mobl>
References: <1330121218-10442-1-git-send-email-grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330121218-10442-1-git-send-email-grant.likely@secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Fri, Feb 24, 2012 at 03:06:58PM -0700, Grant Likely wrote:
> Sparc has its own helpers for translating address ranges when the device
> tree is parsed at boot time, and it isn't able to use of_platform_populate().
> However, there are some device drivers that want to use that function on
> other DT enabled platforms (ie. TWL4030).  This patch adds an empty
> of_platform_populate() implementation that returns an error when
> CONFIG_OF_ADDRESS is not selected.
Applied as well. Please let me know if you'd prefer to see this one going
through your irqdomain/next branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
