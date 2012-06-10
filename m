Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab2FJEtk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 00:49:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:64989 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021Ab2FJEtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 00:49:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="163699730"
Date: Sun, 10 Jun 2012 12:49:34 +0800
From: Fengguang Wu <wfg@linux.intel.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, gaofeng@cn.fujitsu.com,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] inet: Initialize per-netns inetpeer roots in
 net/ipv{4,6}/route.c
Message-ID: <20120610044934.GA10507@localhost>
References: <20120610015832.GA9175@localhost>
 <20120609.190451.182034193302304295.davem@davemloft.net>
 <20120610031634.GA10032@localhost>
 <20120609.212147.1738198233131370927.davem@davemloft.net>
 <20120610044339.GA10436@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120610044339.GA10436@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2012 at 12:43:39PM +0800, Fengguang Wu wrote:
> On Sat, Jun 09, 2012 at 09:21:47PM -0700, David Miller wrote:
> > From: Fengguang Wu <wfg@linux.intel.com>
> > Date: Sun, 10 Jun 2012 11:16:34 +0800
> > 
> > > In long run, such build-fix patches can also be auto tested and
> > > reported, somehow in this way. You just create a temporary branch
> > 
> > Sorry, no.
> 
> That's fine. Then how about including some text "fix build errors" or
> "fix build warnings" or paste the original gcc error/warning messages,
> somewhere in the changelog or subject?
> 
> That will also allow me recognize that it's a build fix commit and to
> make it unconditionally report back any build results.

Or better, simply include a 

        Reported-by: Fengguang Wu <wfg@linux.intel.com>

line in the commit. Then I can reliably detect that it actually tries
to fix some build error/waring reported by me, and verbosely report
back whether the commit actually fix things up.

Thanks,
Fengguang
