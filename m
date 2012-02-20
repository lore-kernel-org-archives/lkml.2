Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab2BTQpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 11:45:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:59173 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221Ab2BTQpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 11:45:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="119396768"
Date: Mon, 20 Feb 2012 17:52:53 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/2] mfd: Convert s5m core driver to use devm_kzalloc()
Message-ID: <20120220165253.GB5387@sortiz-mobl>
References: <1327043352-25037-1-git-send-email-sbkim73@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327043352-25037-1-git-send-email-sbkim73@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sangbeom,

On Fri, Jan 20, 2012 at 04:09:11PM +0900, Sangbeom Kim wrote:
> Convert s5m core driver to use devm_kzalloc().
Thanks, patch applied.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
