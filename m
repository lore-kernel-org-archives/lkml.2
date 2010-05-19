Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab0ESAAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 20:00:34 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53113 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338Ab0ESAAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 20:00:22 -0400
Date: Tue, 18 May 2010 17:00:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: sds@tycho.nsa.gov, eparis@parisplace.org, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, mathieu.desnoyers@efficios.com
Subject: Re: [PATCH] selinux: remove all rcu head initializations
Message-ID: <20100519000019.GM2302@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100518191125.GA7014@linux.vnet.ibm.com>
 <alpine.LRH.2.00.1005190938400.1028@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1005190938400.1028@tundra.namei.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 09:39:03AM +1000, James Morris wrote:
> On Tue, 18 May 2010, Paul E. McKenney wrote:
> 
> > Hello!
> > 
> > Would you guys like to carry this patch, or should I push it up
> > -tip?  If I don't hear otherwise from you, I will push it up -tip.
> > The INIT_RCU_HEAD() primitive is going away in favor of debugobjects.
> > 
> 
> Applied to
> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next-queue

Thank you, I have removed it from my tree.

							Thanx, Paul
