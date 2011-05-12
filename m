Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab1ELLYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 07:24:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:36974 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab1ELLYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 07:24:19 -0400
Subject: Re: [PATCH] sched: rt_rq runtime leakage bug fix
From: Peter Zijlstra <peterz@infradead.org>
To: Cheng Xu <chengxu@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mckenney <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4DCBBC9D.7020908@linux.vnet.ibm.com>
References: <4DCA3C0C.3080901@linux.vnet.ibm.com>
	 <1305105711.2914.205.camel@laptop>  <4DCAC79A.7050505@linux.vnet.ibm.com>
	 <1305195150.2914.268.camel@laptop>  <4DCBBC9D.7020908@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 13:27:22 +0200
Message-ID: <1305199642.2914.270.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-12 at 18:55 +0800, Cheng Xu wrote:
> #define for_each_rt_rq(rt_rq, iter, rq) \
>         for ((void) iter, rt_rq = &rq->rt; rt_rq; rt_rq = NULL)
> 
> maybe we can still use it? 

Sure that looks fine to me, looking fwd to your final patch!

