Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620Ab2ECPrt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 11:47:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37508 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756794Ab2ECPrr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 11:47:47 -0400
Message-ID: <1336060050.22523.23.camel@twins>
Subject: Re: [RFC] sched: make callers check lock contention for
 cond_resched_lock()
From: Peter Zijlstra <peterz@infradead.org>
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kvm@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        yoshikawa.takuya@oss.ntt.co.jp
Date: Thu, 03 May 2012 17:47:30 +0200
In-Reply-To: <20120503220050.e91938418f882b4075526e08@gmail.com>
References: <20120503171244.2debdd80931ccf35f387c5fe@gmail.com>
	 <1336034127.13683.197.camel@twins>
	 <20120503212244.6abbfa8bc3f46a7f7a932bb7@gmail.com>
	 <1336048150.22523.17.camel@twins>
	 <20120503220050.e91938418f882b4075526e08@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-03 at 22:00 +0900, Takuya Yoshikawa wrote:
> But as I could not see why spin_needbreak() was differently
> implemented
> depending on CONFIG_PREEMPT, I wanted to understand the meaning. 

Its been that way since before voluntary preemption was introduced, so
its possible Ingo simply missed that spot and nobody noticed until now.

Ingo, do you have any recollections from back when?
