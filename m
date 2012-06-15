Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab2FOAaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 20:30:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:16754 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157Ab2FOAaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 20:30:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="165870909"
Date: Fri, 15 Jun 2012 08:29:59 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Wanpeng Li <liwp.linux@gmail.com>, linux-kernel@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] writeback: avoid race when update bandwidth
Message-ID: <20120615002959.GA7384@localhost>
References: <1339501561-4570-1-git-send-email-liwp.linux@gmail.com>
 <20120612115219.GA17348@localhost>
 <20120613035920.GV22848@dastard>
 <20120613121434.GA937@localhost>
 <20120614020559.GB7339@dastard>
 <20120614140006.GB15553@localhost>
 <20120615000633.GB25389@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615000633.GB25389@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 10:06:33AM +1000, Dave Chinner wrote:
> On Thu, Jun 14, 2012 at 10:00:06PM +0800, Fengguang Wu wrote:
> > On Thu, Jun 14, 2012 at 12:05:59PM +1000, Dave Chinner wrote:
> > > On Wed, Jun 13, 2012 at 08:14:34PM +0800, Fengguang Wu wrote:
> > I wonder if anyone has a simple script for sorting lock_stat output
> > based on that (and perhaps other selectable) criterion? It should be
> > possible to write on myself, but still.. ;-)
> > 
> > Default lock_stat output is sorted by absolute number of contentions.
> 
> No that I know of. The default is pretty sane, because a highly
> contended lock that is causing performance problems will always show
> up near the top. If it's not in the top 10, then it's usually not
> worth worrying about until you've dealt with the those above it....

Okay, thanks for the tip!

Thanks,
Fengguang
