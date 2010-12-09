Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab0LIN7D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 08:59:03 -0500
Received: from mga01.intel.com ([192.55.52.88]:29895 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755341Ab0LIN7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 08:59:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,320,1288594800"; 
   d="scan'208";a="634721897"
Date: Thu, 9 Dec 2010 14:58:58 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: linux-kernel@vger.kernel.org, achew@nvidia.com, olofj@chromium.org
Subject: Re: [PATCH] mfd: tps6586x: Remove device ID check
Message-ID: <20101209135857.GK8884@sortiz-mobl>
References: <1291314802-18447-1-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291314802-18447-1-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, Dec 02, 2010 at 11:33:22AM -0700, Stephen Warren wrote:
> ... and convert it to a dev_info print at probe time.
> 
> There are many variants of this chip with different values of VERSIONCRC.
> The set of values is large, and not useful to enumerate. All are SW
> compatible. The difference lies in default settings of the various power
> rails, and other similar differences. The driver, or clients of the
> driver, shouldn't be affected by this, since all rails should be
> programmed into the desired state in all cases for correct operation.
Fair enough, but then you can remove the TPS658621A_VERSIONCRC and
TPS658621C_VERSIONCRC defines.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
