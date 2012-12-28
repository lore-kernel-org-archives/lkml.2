Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab2L1Vm5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 16:42:57 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:36618 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192Ab2L1Vmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 16:42:55 -0500
Date: Fri, 28 Dec 2012 16:42:45 -0500
From: Tejun Heo <tj@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 14/25] rfkill: don't use [delayed_]work_pending()
Message-ID: <20121228214245.GH3062@mtj.dyndns.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
 <1356141435-17340-15-git-send-email-tj@kernel.org>
 <1356207733.10280.1.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356207733.10280.1.camel@jlt4.sipsolutions.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 22, 2012 at 09:22:13PM +0100, Johannes Berg wrote:
> On Fri, 2012-12-21 at 17:57 -0800, Tejun Heo wrote:
> > There's no need to test whether a (delayed) work item in pending
> > before queueing, flushing or cancelling it.  Most uses are unnecessary
> > and quite a few of them are buggy.
> > 
> > Remove unnecessary pending tests from rfkill.  Only compile
> > tested.
> 
> Looks fine to me, feel free to route through your tree -- nobody changes
> rfkill much (famous last words...) :-)

Applied to wq/for-3.9-cleanups w/ your Acked-by added.  Thanks.

-- 
tejun
