Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530Ab0LSWn7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 17:43:59 -0500
Received: from mga02.intel.com ([134.134.136.20]:30053 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932403Ab0LSWn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 17:43:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,198,1291622400"; 
   d="scan'208";a="585234357"
Date: Sun, 19 Dec 2010 23:43:54 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: linux-kernel@vger.kernel.org, achew@nvidai.com, olofj@chromium.org
Subject: Re: [PATCH] mfd: tps6586x: Remove device ID check
Message-ID: <20101219224354.GA3206@sortiz-mobl>
References: <20101209135857.GK8884@sortiz-mobl>
 <1291915811-17227-1-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291915811-17227-1-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, Dec 09, 2010 at 10:30:11AM -0700, Stephen Warren wrote:
> ... and convert it to a dev_info print at probe time.
> 
> There are many variants of this chip with different values of VERSIONCRC.
> The set of values is large, and not useful to enumerate. All are SW
> compatible. The difference lies in default settings of the various power
> rails, and other similar differences. The driver, or clients of the
> driver, shouldn't be affected by this, since all rails should be
> programmed into the desired state in all cases for correct operation.
> 
> Derived-from-code-by: Andrew Chew <achew@nvidia.com>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
Patch applied, thanks a lot.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
