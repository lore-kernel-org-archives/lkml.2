Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab1LSLIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 06:08:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:1459 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752Ab1LSLIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 06:08:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="89009538"
Date: Mon, 19 Dec 2011 12:13:11 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jin Park <jinyoungp@nvidia.com>
Subject: Re: [PATCH 1/4] mfd: aat2870-core: Use gpio_request_one
Message-ID: <20111219111311.GB11800@sortiz-mobl>
References: <1322704074.11560.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322704074.11560.3.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Thu, Dec 01, 2011 at 09:47:54AM +0800, Axel Lin wrote:
> Use gpio_request_one() instead of multiple gpiolib calls.
All 4 patches applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
