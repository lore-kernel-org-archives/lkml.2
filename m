Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab1GUSkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 14:40:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:54883 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab1GUSkG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 14:40:06 -0400
Subject: Re: [RFC PATCH] sched: lockdep circular locking error
 (rcu_node_level_0 vs rq->lock)
From: Peter Zijlstra <peterz@infradead.org>
To: Cheng Xu <chengxu@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Paul Mckenney <paulmck@linux.vnet.ibm.com>
In-Reply-To: <4E287177.6020605@linux.vnet.ibm.com>
References: <4E287177.6020605@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 21 Jul 2011 20:39:40 +0200
Message-ID: <1311273580.29152.180.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-22 at 02:35 +0800, Cheng Xu wrote:
> This is an updated version of Peter Zijlstra's patch at
> https://lkml.org/lkml/2011/7/12/344 that successfully boots on IBM JS22
> Blade (with two Power6 quad-core CPUs). It might not be needed, but I am
> posting it just in case.

right, but if at all possible, I'd like to avoid actually doing this
since it adds more code to fairly hot paths. Furthermore it looks like
we sorted all issues in different ways.

But thanks!
