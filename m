Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab1LTBmq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 20:42:46 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:44239 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab1LTBmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 20:42:43 -0500
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
        bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 2/4] sched: Adding gang scheduling infrastrucure
In-Reply-To: <1324313499.24621.18.camel@twins>
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com> <20111219083424.32311.23559.stgit@abhimanyu.in.ibm.com> <1324309904.24621.15.camel@twins> <1324313499.24621.18.camel@twins>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Tue, 20 Dec 2011 07:13:52 +0530
Message-ID: <878vm82f1j.fsf@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 11122001-3864-0000-0000-00000094BA2E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Dec 2011 17:51:39 +0100, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2011-12-19 at 16:51 +0100, Peter Zijlstra wrote:
> > > +                     smp_call_function_many(rq->gang_cpumask,
> > > +                                     gang_sched_member, tg, 0);
> > 
> > See this is just not going to happen. 
> 
> Furthermore its racy against task_group destruction.
> 
Yes, i definitely need to check that part.

Thanks
Nikunj

