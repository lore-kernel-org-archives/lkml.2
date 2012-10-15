Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab2JOTIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 15:08:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63985 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615Ab2JOTIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 15:08:51 -0400
Date: Mon, 15 Oct 2012 21:09:58 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/2] uprobes: register/unregister can race with fork
Message-ID: <20121015190958.GA4799@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Well. The very fact this series adds the new locking primitive
probably means we should try to find another fix. And yes, it is
possible to fix this differently, afaics. But this will need
more complications, I think.

So please review. As for 1/2:

	- I really hope paulmck/peterz will tell me if it is
	  correct or not

	- The naming sucks, and I agree with any suggestions

	- Probably this code should be compiled only if
	  CONFIG_UPRPOBES

Oleg.

