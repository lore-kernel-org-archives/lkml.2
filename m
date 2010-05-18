Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab0ERXjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 19:39:22 -0400
Received: from tundra.namei.org ([65.99.196.166]:47989 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338Ab0ERXjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 19:39:21 -0400
Date: Wed, 19 May 2010 09:39:03 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: sds@tycho.nsa.gov, eparis@parisplace.org, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, mathieu.desnoyers@efficios.com
Subject: Re: [PATCH] selinux: remove all rcu head initializations
In-Reply-To: <20100518191125.GA7014@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.2.00.1005190938400.1028@tundra.namei.org>
References: <20100518191125.GA7014@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 May 2010, Paul E. McKenney wrote:

> Hello!
> 
> Would you guys like to carry this patch, or should I push it up
> -tip?  If I don't hear otherwise from you, I will push it up -tip.
> The INIT_RCU_HEAD() primitive is going away in favor of debugobjects.
> 

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next-queue


-- 
James Morris
<jmorris@namei.org>
