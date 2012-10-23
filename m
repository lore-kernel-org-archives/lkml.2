Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276Ab2JWQe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 12:34:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:18478 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755138Ab2JWQez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 12:34:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,635,1344236400"; 
   d="scan'208";a="239073498"
Date: Tue, 23 Oct 2012 09:34:43 -0700
From: Andi Kleen <ak@linux.intel.com>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        eranian@google.com
Subject: Re: [PATCH 1/6] perf, x86: Basic Haswell LBR call stack support
Message-ID: <20121023163443.GS2095@tassilo.jf.intel.com>
References: <1350886279-6141-1-git-send-email-zheng.z.yan@intel.com>
 <1350886279-6141-2-git-send-email-zheng.z.yan@intel.com>
 <1350902138.2768.86.camel@twins>
 <50862E02.6020002@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50862E02.6020002@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > You add an ABI sample type without mentioning it in your changelog.. I
> > think I'll stop reading here.
> > 
> Ok, I will add the ABI change to the change log. Do you think we should hide this
> branch sample type from user?

Yes I would hide it. No need to expose, except as a callstack.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only
