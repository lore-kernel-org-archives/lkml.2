Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab0ERW7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 18:59:30 -0400
Received: from tundra.namei.org ([65.99.196.166]:55308 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084Ab0ERW73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 18:59:29 -0400
Date: Wed, 19 May 2010 08:59:07 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: sds@tycho.nsa.gov, eparis@parisplace.org, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, mathieu.desnoyers@efficios.com
Subject: Re: [PATCH] selinux: remove all rcu head initializations
In-Reply-To: <20100518191125.GA7014@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.2.00.1005190858180.640@tundra.namei.org>
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

Are there any prerequisites for this patch?  If not, I'll take it.


-- 
James Morris
<jmorris@namei.org>
