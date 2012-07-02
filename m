Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab2GBVAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 17:00:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:28136 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754Ab2GBVAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 17:00:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="187666196"
Date: Mon, 2 Jul 2012 14:00:08 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] perf, x86: Enable PDIR precise instruction profiling
 on IvyBridge
Message-ID: <20120702210008.GB14479@tassilo.jf.intel.com>
References: <1341254598-1379-1-git-send-email-andi@firstfloor.org>
 <1341254598-1379-3-git-send-email-andi@firstfloor.org>
 <1341256733.23484.11.camel@twins>
 <20120702195744.GG11413@one.firstfloor.org>
 <1341260540.23484.25.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341260540.23484.25.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If anything its an PEBS alias, we have infrastructure for that, yet you
> invent new things.

Ok.
> 
> You do random things like only :pp for no apparent reason.

At which p level do you want it? Or on by default?

> 
> PDIR is only supported on a single counter, regular PEBS 'instructions'
> events allow for 4+ counters. Therefore a direct substitution is not
> valid.

Ok so you want a new flag? Or a new event?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
