Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415Ab2C2OKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 10:10:46 -0400
Received: from mga14.intel.com ([143.182.124.37]:53456 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408Ab2C2OKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 10:10:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="124815437"
Date: Thu, 29 Mar 2012 22:05:25 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: David Rientjes <rientjes@google.com>, Borislav Petkov <bp@amd64.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm/memory_failure: Let the compiler add the function name
Message-ID: <20120329140525.GA10452@localhost>
References: <1332843450-7100-1-git-send-email-bp@amd64.org>
 <alpine.DEB.2.00.1203280018390.16201@chino.kir.corp.google.com>
 <20120328090909.GX22197@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120328090909.GX22197@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 11:09:09AM +0200, Andi Kleen wrote:
> > I agree with your change, but I'm not sure these should be pr_info() to 
> > start with, these seem more like debugging messages?  I can't see how 
> > they'd be useful in standard operation so could we just convert them to be 
> > debug instead?
> 
> Well it tells why the page recovery didn't work.
> 
> Memory recovery is a somewhat obscure path, so it's better to have
> full information.

Nod, and it won't disturb the users unless something really bad happens.

I'm fine with the patch, too.

Thanks,
Fengguang
