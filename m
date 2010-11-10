Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230Ab0KJRTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 12:19:53 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:23980 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757170Ab0KJRTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 12:19:52 -0500
Date: Wed, 10 Nov 2010 09:19:26 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 10 (kernel/rcutiny)
Message-Id: <20101110091926.dc834e84.randy.dunlap@oracle.com>
In-Reply-To: <20101110140719.139ebe51.sfr@canb.auug.org.au>
References: <20101110140719.139ebe51.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Nov 2010 14:07:19 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20101109:


when CONFIG_RCU_BOOST is not enabled:

In file included from linux-next-20101110/kernel/rcutiny.c:53:
linux-next-20101110/kernel/rcutiny_plugin.h: In function 'rcu_preempt_cpu_qs':
linux-next-20101110/kernel/rcutiny_plugin.h:413: error: 'struct rcu_preempt_ctrlblk' has no member named 'n_normal_balk_blkd_tasks'

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
