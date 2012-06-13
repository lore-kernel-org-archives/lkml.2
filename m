Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab2FMWE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 18:04:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:38442 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908Ab2FMWEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 18:04:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="179667263"
Date: Wed, 13 Jun 2012 15:04:55 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] perf, x86: Enable PDIR precise instruction profiling
 on IvyBridge
Message-ID: <20120613220455.GI32604@tassilo.jf.intel.com>
References: <1339615201-7456-1-git-send-email-andi@firstfloor.org>
 <1339615201-7456-2-git-send-email-andi@firstfloor.org>
 <1339622781.8980.63.camel@twins>
 <20120613213651.GD32604@tassilo.jf.intel.com>
 <1339623838.8980.71.camel@twins>
 <20120613215424.GG32604@tassilo.jf.intel.com>
 <1339624738.8980.77.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339624738.8980.77.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 11:58:58PM +0200, Peter Zijlstra wrote:
> On Wed, 2012-06-13 at 14:54 -0700, Andi Kleen wrote:
> > Yes it's in effect, and it forces the event to counter 1. 
> > That is correct and that restriction is still there. 
> 
> OK, when we cannot magically replace 'instructions' with pdir.

Why not?  You want a new event?

It's still retired instructions, just sampled in a slightly different way.

Today instructions:pp just errors out BTW, so nothing should rely on it.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only
