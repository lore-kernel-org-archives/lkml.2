Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab2FOAGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 20:06:40 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:9135 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756337Ab2FOAGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 20:06:37 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak0JAI572k95LAcV/2dsb2JhbABFtA0EgSuBCIIYAQEFOhwjEAgDGC4UJQMhE4gKuhkUix5JhGhgA5Ugj32Ccg
Date: Fri, 15 Jun 2012 10:06:33 +1000
From: Dave Chinner <david@fromorbit.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Wanpeng Li <liwp.linux@gmail.com>, linux-kernel@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] writeback: avoid race when update bandwidth
Message-ID: <20120615000633.GB25389@dastard>
References: <1339501561-4570-1-git-send-email-liwp.linux@gmail.com>
 <20120612115219.GA17348@localhost>
 <20120613035920.GV22848@dastard>
 <20120613121434.GA937@localhost>
 <20120614020559.GB7339@dastard>
 <20120614140006.GB15553@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120614140006.GB15553@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 10:00:06PM +0800, Fengguang Wu wrote:
> On Thu, Jun 14, 2012 at 12:05:59PM +1000, Dave Chinner wrote:
> > On Wed, Jun 13, 2012 at 08:14:34PM +0800, Fengguang Wu wrote:
> I wonder if anyone has a simple script for sorting lock_stat output
> based on that (and perhaps other selectable) criterion? It should be
> possible to write on myself, but still.. ;-)
> 
> Default lock_stat output is sorted by absolute number of contentions.

No that I know of. The default is pretty sane, because a highly
contended lock that is causing performance problems will always show
up near the top. If it's not in the top 10, then it's usually not
worth worrying about until you've dealt with the those above it....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
