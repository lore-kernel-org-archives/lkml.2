Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab1LSQvs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 11:51:48 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54570 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab1LSQvp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 11:51:45 -0500
Message-ID: <1324313499.24621.18.camel@twins>
Subject: Re: [RFC PATCH 2/4] sched: Adding gang scheduling infrastrucure
From: Peter Zijlstra <peterz@infradead.org>
To: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
        bharata@linux.vnet.ibm.com
Date: Mon, 19 Dec 2011 17:51:39 +0100
In-Reply-To: <1324309904.24621.15.camel@twins>
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com>
	 <20111219083424.32311.23559.stgit@abhimanyu.in.ibm.com>
	 <1324309904.24621.15.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-19 at 16:51 +0100, Peter Zijlstra wrote:
> > +                     smp_call_function_many(rq->gang_cpumask,
> > +                                     gang_sched_member, tg, 0);
> 
> See this is just not going to happen. 

Furthermore its racy against task_group destruction.
