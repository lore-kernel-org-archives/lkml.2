Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab0HSVJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 17:09:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:3206 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789Ab0HSVJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 17:09:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,235,1280732400"; 
   d="scan'208";a="598369618"
Date: Fri, 20 Aug 2010 05:09:07 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@linux.intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li, Shaohua" <shaohua.li@intel.com>
Subject: Re: [TESTCASE] Clean pages clogging the VM
Message-ID: <20100819210907.GA22747@localhost>
References: <20100809133000.GB6981@wil.cx>
 <20100817195001.GA18817@linux.intel.com>
 <20100818141308.GD1779@cmpxchg.org>
 <20100818160613.GE9431@localhost>
 <20100818160731.GA15002@localhost>
 <20100819115106.GG1779@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100819115106.GG1779@cmpxchg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 07:51:06PM +0800, Johannes Weiner wrote:
> I am currently trying to get rid of all the congestion_wait() in the VM.
> They are used for different purposes, so they need different replacement
> mechanisms.
> 
> I saw Shaohua's patch to make congestion_wait() cleverer.  But I really
> think that congestion is not a good predicate in the first place.  Why
> would the VM care about IO _congestion_?  It needs a bunch of pages to
> complete IO, whether the writing device is congested is not really
> useful information at this point, I think.

I have the same feeling that the congestion_wait() calls are not
pertinent ones.  I'm glad to see people working on that exploring
all possible replacement schemes.

Thanks,
Fengguang
