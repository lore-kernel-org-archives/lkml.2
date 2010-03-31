Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294Ab0CaOEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 10:04:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453Ab0CaOEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 10:04:41 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100331000832.GQ2513@linux.vnet.ibm.com>
References: <20100331000832.GQ2513@linux.vnet.ibm.com> <20100329192159.GM2569@linux.vnet.ibm.com> <20100319022527.GC2894@linux.vnet.ibm.com> <20100318133302.29754.1584.stgit@warthog.procyon.org.uk> <19192.1269889348@redhat.com> <23274.1269893706@redhat.com> <25276.1269901350@redhat.com> <26760.1269903543@redhat.com> <20100329232636.GT2569@linux.vnet.ibm.com> <2440.1269967151@redhat.com> <21972.1269993064@redhat.com> 
To: paulmck@linux.vnet.ibm.com
Cc: dhowells@redhat.com, Eric Dumazet <eric.dumazet@gmail.com>,
       Trond.Myklebust@netapp.com, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFS: Fix RCU warnings in nfs_inode_return_delegation_noreclaim() [ver #2]
Date: Wed, 31 Mar 2010 15:04:33 +0100
Message-ID: <10818.1270044273@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> How about Eric's suggestion of rcu_dereference_protected()?  That name
> doesn't imply a lock, which as you say above, isn't always needed to
> keep the structure from changing.

But 'protected' from what or by what?

David
