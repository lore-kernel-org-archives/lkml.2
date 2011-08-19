Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab1HSAiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 20:38:21 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:41661 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716Ab1HSAiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 20:38:20 -0400
Date: Thu, 18 Aug 2011 17:38:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Josh Boyer <jwboyer@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: 3.0-git15 Atomic scheduling in pidmap_init
Message-ID: <20110819003817.GJ2325@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110817224916.GO2419@linux.vnet.ibm.com>
 <20110817230219.GJ2227@zod.bos.redhat.com>
 <20110817230641.GA7837@somewhere.redhat.com>
 <20110817231750.GK2227@zod.bos.redhat.com>
 <20110818183523.GD2325@linux.vnet.ibm.com>
 <20110818140034.668e8dea.akpm@linux-foundation.org>
 <20110818212334.GE2325@linux.vnet.ibm.com>
 <20110818221920.GR2227@zod.bos.redhat.com>
 <20110818231646.GH2325@linux.vnet.ibm.com>
 <20110818162723.aa63bc38.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110818162723.aa63bc38.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 04:27:23PM -0700, Andrew Morton wrote:
> On Thu, 18 Aug 2011 16:16:46 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > Andrew, are you willing to ack this?
> 
> WhoMeNope.  That would imply that I understood it, but my brain is far
> too small to understand rcutree.c - that's what we have paulmcks for.

Yeah, well, the only reason my brain can encompass rcutree.c is that
there is not much else there.  I will CC you when submitting the patch.

							Thanx, Paul
