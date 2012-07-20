Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab2GTV6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 17:58:47 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40863 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab2GTV6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 17:58:40 -0400
Date: Fri, 20 Jul 2012 14:58:35 -0700
From: Tejun Heo <tj@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de, linux-pm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/9] workqueue: perform cpu down operations from low
 priority cpu_notifier()
Message-ID: <20120720215835.GB6823@google.com>
References: <1342545149-3515-1-git-send-email-tj@kernel.org>
 <1342545149-3515-2-git-send-email-tj@kernel.org>
 <20120720215207.GA18841@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120720215207.GA18841@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Paul.

On Fri, Jul 20, 2012 at 02:52:07PM -0700, Paul E. McKenney wrote:
> > Fix it by using different priorities for up and down notifiers - high
> > priority for up operations and low priority for down operations.
> 
> Cool!!!
> 
> This certainly provides another data point in favor of running down
> notifiers in the opposite order from up notifiers.  ;-)

Yeah, I was thinking about that.  I don't think converting CPU
notifiers would take a lot of work in terms of both auditing and
converting.  We only have several priorities.

> This series passes light rcutorture/hotplug testing, will be testing
> it more.

Great!

-- 
tejun
