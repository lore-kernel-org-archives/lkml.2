Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab2L1VpD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 16:45:03 -0500
Received: from mail-vb0-f53.google.com ([209.85.212.53]:36562 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab2L1Voz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 16:44:55 -0500
Date: Fri, 28 Dec 2012 16:44:51 -0500
From: "'Tejun Heo'" <tj@kernel.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Kukjin Kim'" <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>
Subject: Re: [PATCH 23/25] video/exynos: don't use [delayed_]work_pending()
Message-ID: <20121228214451.GK3062@mtj.dyndns.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
 <1356141435-17340-24-git-send-email-tj@kernel.org>
 <00af01cddff1$4170db40$c45291c0$@samsung.com>
 <02f901cde31e$0a284df0$1e78e9d0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02f901cde31e$0a284df0$1e78e9d0$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 26, 2012 at 01:04:02PM +0900, Jingoo Han wrote:
> On Saturday, December 22, 2012 12:06 PM, Kukjin Kim wrote 
> > Tejun Heo wrote:
> > >
> > > There's no need to test whether a (delayed) work item in pending
> > > before queueing, flushing or cancelling it.  Most uses are unnecessary
> > > and quite a few of them are buggy.
> > >
> > > Remove unnecessary pending tests from exynos_dp_core.  Only compile
> > > tested.
> > >
> > > Signed-off-by: Tejun Heo <tj@kernel.org>
> > > Cc: Kukjin Kim <kgene.kim@samsung.com>
> > 
> > Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> 
> Acked-by: Jingoo Han <jg1.han@samsung.com>
> 
> I tested this patch with Exynos5250.
> Also, taking it through the workqueue tree would be better.

Applied to wq/for-3.9-cleanups.  Thanks!

-- 
tejun
