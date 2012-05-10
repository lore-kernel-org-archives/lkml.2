Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761774Ab2EJWEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 18:04:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43607 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761711Ab2EJWEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 18:04:02 -0400
Date: Fri, 11 May 2012 07:03:57 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kvm@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        yoshikawa.takuya@oss.ntt.co.jp
Subject: Re: [RFC] sched: make callers check lock contention for
 cond_resched_lock()
Message-Id: <20120511070357.9bf8f9b6636a12927f26bfed@gmail.com>
In-Reply-To: <1336060050.22523.23.camel@twins>
References: <20120503171244.2debdd80931ccf35f387c5fe@gmail.com>
	<1336034127.13683.197.camel@twins>
	<20120503212244.6abbfa8bc3f46a7f7a932bb7@gmail.com>
	<1336048150.22523.17.camel@twins>
	<20120503220050.e91938418f882b4075526e08@gmail.com>
	<1336060050.22523.23.camel@twins>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced Ingo's address with kernel.org one,

On Thu, 03 May 2012 17:47:30 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2012-05-03 at 22:00 +0900, Takuya Yoshikawa wrote:
> > But as I could not see why spin_needbreak() was differently
> > implemented
> > depending on CONFIG_PREEMPT, I wanted to understand the meaning. 
> 
> Its been that way since before voluntary preemption was introduced, so
> its possible Ingo simply missed that spot and nobody noticed until now.
> 
> Ingo, do you have any recollections from back when?

ping

	Takuya
