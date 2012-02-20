Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab2BTPQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 10:16:58 -0500
Received: from mga03.intel.com ([143.182.124.21]:39720 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215Ab2BTPQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 10:16:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="108651255"
Date: Mon, 20 Feb 2012 16:24:07 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: jhbird.choi@samsung.com
Cc: linux-kernel@vger.kernel.org, Sangbeom Kim <sbkim73@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] mfd: s5m: fix error handling for invalid device type
Message-ID: <20120220152407.GX5387@sortiz-mobl>
References: <1326696741-23353-1-git-send-email-jhbird.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326696741-23353-1-git-send-email-jhbird.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonghwan,

On Mon, Jan 16, 2012 at 03:52:21PM +0900, jhbird.choi@samsung.com wrote:
> From: Jonghwan Choi <jhbird.choi@samsung.com>
> 
> If device type is not supported in driver, have to retun error.
I applied this one, after fixing the > 80 chars issues.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
