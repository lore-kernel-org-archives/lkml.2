Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab2FMNcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 09:32:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:49970 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754033Ab2FMNcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 09:32:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="165142766"
Date: Wed, 13 Jun 2012 21:32:17 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] iwldvm lock oops
Message-ID: <20120613133217.GA2170@localhost>
References: <20120613131725.GA2052@localhost>
 <1339593640.4519.39.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339593640.4519.39.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

On Wed, Jun 13, 2012 at 03:20:40PM +0200, Johannes Berg wrote:
> Hi Fengguang,
> 
> > The kernel compiled from commit b35032f ("iwlwifi: don't configure a
> > txq that is being disabled") in
> > 
> >         git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git  master
> > 
> > triggers a kernel oops below.
> > 
> > That particular commit may well not be the root cause. I'm just hoping
> > you may have better idea which recent change may be relevant.
> 
> Thanks for the report. This particular problem is due to the fact that
> we have the objects linked into the kernel in the wrong order, we have a
> fix pending for it. git.kernel.org is down right now so I can't link to
> it, but it's in the iwlwifi/iwlwifi-next.git tree:
> 
> commit 65fe593a519c4d7c62289d3b0a17ca412e95b037
> Author: Brandon Misemer <brandon.misemer@intel.com>
> Date:   Fri Jun 8 14:59:27 2012 -0700
> 
>     iwlwifi: Fix Makefile build order for built-in driver

Good to know this. Thank you for the quick feedback!

Thanks,
Fengguang
