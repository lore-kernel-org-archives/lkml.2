Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab2L1Vm0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 16:42:26 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:35856 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab2L1VmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 16:42:22 -0500
Date: Fri, 28 Dec 2012 16:42:18 -0500
From: Tejun Heo <tj@kernel.org>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 09/25] wl1251: don't use [delayed_]work_pending()
Message-ID: <20121228214218.GG3062@mtj.dyndns.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
 <1356141435-17340-10-git-send-email-tj@kernel.org>
 <1356185669.20841.9.camel@cumari.coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356185669.20841.9.camel@cumari.coelho.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 22, 2012 at 04:14:29PM +0200, Luciano Coelho wrote:
> On Fri, 2012-12-21 at 17:56 -0800, Tejun Heo wrote:
> > There's no need to test whether a (delayed) work item in pending
> > before queueing, flushing or cancelling it.  Most uses are unnecessary
> > and quite a few of them are buggy.
> > 
> > Remove unnecessary pending tests from wl1251.  Only compile tested.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: Luciano Coelho <coelho@ti.com>
> > Cc: linux-wireless@vger.kernel.org
> > ---
> > Please let me know how this patch should be routed.  I can take it
> > through the workqueue tree if necessary.
> > 
> > Thanks.
> 
> It's probably easier if you take it via your tree.  This driver doesn't
> get patches very often, so I doubt there will be any conflicts.
> 
> Thank you!
> 
> Acked-by: Luciano Coelho <coelho@ti.com>

Applied to wq/for-3.9-cleanups.  Thanks.

-- 
tejun
