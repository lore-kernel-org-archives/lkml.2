Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376Ab2CALAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 06:00:49 -0500
Received: from mga14.intel.com ([143.182.124.37]:57295 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758494Ab2CALAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 06:00:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="113239207"
Date: Thu, 1 Mar 2012 12:08:18 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sangbeom Kim <sbkim73@samsung.com>
Subject: Re: [PATCH] mfd: s5m-core: return proper error if regmap_init_i2c
 fails
Message-ID: <20120301110818.GH9008@sortiz-mobl>
References: <1330410235.4654.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330410235.4654.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Tue, Feb 28, 2012 at 02:23:55PM +0800, Axel Lin wrote:
> Also remove a redundant semicolon from return statement.
Thanks, applied.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
