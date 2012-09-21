Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060Ab2IUVG7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 17:06:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:12603 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461Ab2IUVG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 17:06:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,464,1344236400"; 
   d="scan'208";a="147710279"
Date: Fri, 21 Sep 2012 14:06:57 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kgdb: Fix warning with !CONFIG_DEBUG_RODATA
Message-ID: <20120921210657.GD665@tassilo.jf.intel.com>
References: <1348261150-12423-1-git-send-email-andi@firstfloor.org>
 <505CD5C3.3020009@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <505CD5C3.3020009@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 04:01:55PM -0500, Jason Wessel wrote:
> On 09/21/2012 03:59 PM, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > Fixes
> > 
> > arch/x86/kernel/kgdb.c: In function ‘kgdb_arch_set_breakpoint’:
> > arch/x86/kernel/kgdb.c:749:7: warning: unused variable ‘opc’ [-Wunused-variable]
> > 
> > when CONFIG_DEBUG_RODATA is not defined.
> > 
> 
> This is already pending along with other fixes in kgdb-next / linux next for the 3.7 merge window.

Ok.  This was broken in 3.5 too. Next time please fast track warning fixes.

It's about the only warning in my standard builds.

-Andi
