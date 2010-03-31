Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab0CaXfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 19:35:55 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:12010 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab0CaXfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 19:35:54 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMZ4s0urR7Ht/2dsb2JhbACbOXGbZpkchQAEgyM
X-IronPort-AV: E=Sophos;i="4.51,344,1267401600"; 
   d="scan'208";a="506367718"
From: Roland Dreier <rdreier@cisco.com>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: "lkml\, " <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Peter Morreale <pmorreale@novell.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: RFC: Ideal Adaptive Spinning Conditions
References: <4BB3D90C.3030108@us.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 31 Mar 2010 16:35:53 -0700
In-Reply-To: <4BB3D90C.3030108@us.ibm.com> (Darren Hart's message of "Wed, 31
	Mar 2010 16:21:48 -0700")
Message-ID: <adaeij0gj3a.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > I'm looking at some adaptive spinning with futexes as a way to help
 > reduce the dependence on sched_yield() to implement userspace
 > spinlocks. Chris, I included you in the CC after reading your comments
 > regarding sched_yield() at kernel summit and I thought you might be
 > interested.

I think you may have the wrong Chris.  Chris Wright wasn't at the most
recent kernel summit and I do have a vague recollection of Chris Mason
mentioning that Oracle developers found that sched_yield() performed
better than futexes + kernel scheduling.
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
