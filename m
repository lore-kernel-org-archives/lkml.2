Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab1I1NZx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 09:25:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:46609 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab1I1NZw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 09:25:52 -0400
Subject: Re: [RFC] Introduce greedy hrtimer walk on idle
From: Peter Zijlstra <peterz@infradead.org>
To: Venki Pallipadi <venki@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 28 Sep 2011 15:25:15 +0200
In-Reply-To: <CABeCy1Zn0GbAzFBYk1mkDvfEwr4L8DZ-ZhweXaUwWN=3sJnmSQ@mail.gmail.com>
References: <1316804080-6396-1-git-send-email-venki@google.com>
	 <1316807718.9084.48.camel@twins>
	 <CABeCy1Zn0GbAzFBYk1mkDvfEwr4L8DZ-ZhweXaUwWN=3sJnmSQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317216315.24040.20.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-23 at 16:41 -0700, Venki Pallipadi wrote:
> On Fri, Sep 23, 2011 at 12:55 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Fri, 2011-09-23 at 11:54 -0700, Venkatesh Pallipadi wrote:
> >> Comments?
> >
> > One of the reasons we didn't do it before was added cost to
> > hrtimer_{add,del}, did you measure workloads that are heavy on  that?
> >
> 
> I haven't seen any measurable overhead with workloads I have tried.
> But, I don't think I have hit that path hard enough. Do you have any
> particular workload in mind?

Not really, I asked tglx if he knew a particular workload to test this,
but he didn't have anything either.


