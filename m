Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022Ab2IMIqB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 04:46:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:40255 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab2IMIpz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 04:45:55 -0400
Message-ID: <1347525949.15764.109.camel@twins>
Subject: Re: [RFC] sched: nohz_idle_balance
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, mingo@redhat.com,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Date: Thu, 13 Sep 2012 10:45:49 +0200
In-Reply-To: <CAKfTPtCoYjiZphPqyYtmEN-jR=hbAUMLbWSkD9BoWRiVkmE=3Q@mail.gmail.com>
References: <1347509486-8688-1-git-send-email-vincent.guittot@linaro.org>
	 <1347518991.6821.45.camel@marge.simpson.net>
	 <CAKfTPtBQ7Y1xGOe9NZw8AhNbOzGgkVMgYyXjVa1d308kdG6bfQ@mail.gmail.com>
	 <1347521382.6821.61.camel@marge.simpson.net>
	 <CAKfTPtCvg1qxUv02-dO9qD2HiFzS_bA2Gr0mrN=8LEA3eXA7Bg@mail.gmail.com>
	 <1347522994.6821.67.camel@marge.simpson.net>
	 <CAKfTPtCoYjiZphPqyYtmEN-jR=hbAUMLbWSkD9BoWRiVkmE=3Q@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-13 at 10:37 +0200, Vincent Guittot wrote:
> > I think you need to present numbers showing benefit.  Crawling all over
> > a mostly idle (4096p?) box is decidedly bad thing to do. 

Yeah, but we're already doing that anyway.. we know nohz idle balance
doesn't scale. Venki and Suresh were working on that, but with Venki
switching jobs this work got dropped.

I did talk to Suresh about it a week or so ago.. I think he was going to
look at it again.
