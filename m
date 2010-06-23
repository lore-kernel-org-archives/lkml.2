Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab0FWOBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 10:01:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54317 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914Ab0FWOBb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 10:01:31 -0400
Subject: Re: [PATCH 2/2] rcu: simplify the usage of percpu data
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>, "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4C21DC37.9040503@cn.fujitsu.com>
References: <4C21DC37.9040503@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 23 Jun 2010 16:01:17 +0200
Message-ID: <1277301677.1875.827.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-23 at 18:04 +0800, Lai Jiangshan wrote:
> +       struct rcu_data *rdp = per_cpu_ptr(rsp->rda, smp_processor_id());

 this_cpu_ptr(rsp->rda);
