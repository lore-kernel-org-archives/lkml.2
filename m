Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab2BTPLE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 10:11:04 -0500
Received: from mga14.intel.com ([143.182.124.37]:14599 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657Ab2BTPLC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 10:11:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="108650140"
Date: Mon, 20 Feb 2012 16:18:13 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: jhbird.choi@samsung.com
Cc: linux-kernel@vger.kernel.org, Sangbeom Kim <sbkim73@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] mfd: s5m: Fix possible null pointer dereference
Message-ID: <20120220151812.GW5387@sortiz-mobl>
References: <1326672522-10947-1-git-send-email-jhbird.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326672522-10947-1-git-send-email-jhbird.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonghwan,

On Mon, Jan 16, 2012 at 09:08:42AM +0900, jhbird.choi@samsung.com wrote:
> From: Jonghwan Choi <jhbird.choi@samsung.com>
> 
> This patch checks for pdata to using it.
Thanks, I applied it.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
