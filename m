Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab2GTM6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 08:58:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49121 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab2GTM6v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 08:58:51 -0400
Message-ID: <1342789099.2583.1.camel@twins>
Subject: Re: [PATCH] sched/numa: recovered SD_PERFER_SIBLING on CPU domain
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Alex Shi <alex.shi@intel.com>
Cc: tj@kernel.org, mingo@kernel.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Date: Fri, 20 Jul 2012 14:58:19 +0200
In-Reply-To: <1342765190-21540-1-git-send-email-alex.shi@intel.com>
References: <1342765190-21540-1-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-20 at 14:19 +0800, Alex Shi wrote:
> commit 8e7fbcbc22c(sched: Remove stale power aware scheduling remnants
> and dysfunctional knobs) removed SD_PERFER_SIBLING on CPU domain
> On numa machine, that causes load_balance didn't perfer LCPU in same
> physical CPU package.
> 
> It causes some regression on our numa machines from core2 to NHM and SNB.
> Recover this domain flag can recover the performance drop.
> 
> This recovery doesn't has any bad impact on my all benchmarks specjbb,
> kbuild, fio, hackbench .. etc, on all my machines.
> Since it is a recovery, I assume it also has no bad impact for other
> platforms.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>

Thanks!
