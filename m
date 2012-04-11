Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab2DKJT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 05:19:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:21803 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755749Ab2DKJT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 05:19:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="131109910"
Date: Wed, 11 Apr 2012 12:21:10 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, benh@kernel.crashing.org
Subject: Re: [PATCH 2/2] irq_domain: fix formatting of chip data pointer in
 virq_debug_show()
Message-ID: <20120411092110.GB2258@intel.com>
References: <1334060743-7901-1-git-send-email-mika.westerberg@linux.intel.com>
 <1334060743-7901-2-git-send-email-mika.westerberg@linux.intel.com>
 <20120410232708.CAC3D3E079B@localhost>
 <20120411054728.A6C093E081E@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120411054728.A6C093E081E@localhost>
Organization: Intel Finland Oy - BIC 0357606-4 - PL 281, 00181 Helsinki
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 11:47:28PM -0600, Grant Likely wrote:
> 
> I've dropped this one again.  There is actually an easier way to
> achieve the same result.  By dropping the precision entirely from the
> format string the output will always get 0 extended.  I'll post an
> alternate patch soon.

Yeah, that sounds simpler as well. Thanks for fixing it.
