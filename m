Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712Ab2FFRsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 13:48:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54975 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181Ab2FFRsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 13:48:17 -0400
Date: Wed, 6 Jun 2012 19:48:12 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org, eranian@google.com
Subject: Re: [PATCH 1/5] perf, x86: Don't assume the alternative cycles encoding is architectural
Message-ID: <20120606174812.GI27374@one.firstfloor.org>
References: <20120606141247.GD28225@tassilo.jf.intel.com> <1338992061.2749.111.camel@twins> <20120606142323.GG28225@tassilo.jf.intel.com> <1338992910.2749.121.camel@twins> <20120606143536.GH28225@tassilo.jf.intel.com> <1338993726.2749.125.camel@twins> <20120606144952.GK28225@tassilo.jf.intel.com> <1338994385.2749.130.camel@twins> <20120606160848.GG27374@one.firstfloor.org> <1339002645.2749.151.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339002645.2749.151.camel@twins>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 07:10:45PM +0200, Peter Zijlstra wrote:
> On Wed, 2012-06-06 at 18:08 +0200, Andi Kleen wrote:
> > How about newer unknown Intel CPUs with arch_perfmon >= 3? Those would get 
> > intel_pmu, correct?  There's no guarantee that they support the trick.
> 
> But they will have no PEBS constraints set, so effectively don't have
> PEBS.

Ok. I see you want to do it tricky instead of obvious.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
