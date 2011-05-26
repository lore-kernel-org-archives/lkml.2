Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992Ab1EZQEd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 12:04:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:55687 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab1EZQEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 12:04:32 -0400
Subject: Re: [PATCH] sched_rt: RCU-protect for_each_domain() within
 find_lowest_rq()
From: Peter Zijlstra <peterz@infradead.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110526160137.GA5716@swordfish.minsk.epam.com>
References: <20110526160137.GA5716@swordfish.minsk.epam.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 May 2011 18:07:51 +0200
Message-ID: <1306426071.2497.82.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-26 at 19:01 +0300, Sergey Senozhatsky wrote:
> Protect for_each_domain() within find_lowest_rq() with RCU read-side critical 
> section, suppressing suspicious rcu_dereference_check():

I just found:
http://lkml.kernel.org/r/1303469634-11678-1-git-send-email-dfeng@redhat.com in my inbox and queued that.



