Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759085Ab1CaSu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 14:50:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759070Ab1CaSu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 14:50:56 -0400
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
Date: Thu, 31 Mar 2011 19:50:40 +0100
Message-ID: <16158.1301597440@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> The rcu callback user_update_rcu_disposal() just calls a kfree(),
> so we use kfree_rcu() instead of the call_rcu(user_update_rcu_disposal).
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Nice idea, but how do you handle the container_of()?

David
