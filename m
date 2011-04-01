Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948Ab1DAP1v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 11:27:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757795Ab1DAP1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 11:27:50 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4D82DB5B.9000302@cn.fujitsu.com>
References: <4D82DB5B.9000302@cn.fujitsu.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: dhowells@redhat.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, James Morris <jmorris@namei.org>,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 31/36] security,rcu: convert call_rcu(user_update_rcu_disposal) to kfree_rcu()
Date: Fri, 01 Apr 2011 16:27:30 +0100
Message-ID: <8130.1301671650@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> The rcu callback user_update_rcu_disposal() just calls a kfree(),
> so we use kfree_rcu() instead of the call_rcu(user_update_rcu_disposal).
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Acked-by: David Howells <dhowells@redhat.com>
