Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759018Ab0E0Lpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 07:45:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38883 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755072Ab0E0Lpa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 07:45:30 -0400
Subject: Re: [PATCH 00/11] V4: rwsem changes + down_read_critical() proposal
From: Peter Zijlstra <peterz@infradead.org>
To: Michel Lespinasse <walken@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
In-Reply-To: <20100527110210.GB20625@google.com>
References: <1274733081-4623-1-git-send-email-walken@google.com>
	 <1274777239.5882.581.camel@twins>
	 <AANLkTikbeXjmRW4gqiy1Ss-Suce5gIM4xJ5o9Z81ZTQX@mail.gmail.com>
	 <1274779675.5882.684.camel@twins>
	 <20100526102359.da18b89e.kamezawa.hiroyu@jp.fujitsu.com>
	 <20100527110210.GB20625@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 May 2010 13:45:11 +0200
Message-ID: <1274960711.27810.4521.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-27 at 04:02 -0700, Michel Lespinasse wrote:
> > Hmm..can't we use something speculative lookup for reading maps ?
> > (as we played in several months ago...)
> 
> Would you happen to have a link to that conversation / remember the
> subject line of the thread ? 

http://lkml.org/lkml/2009/12/24/153

My last series of patches lives here:

http://programming.kicks-ass.net/kernel-patches/speculative-fault/


