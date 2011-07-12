Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab1GLM4B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 08:56:01 -0400
Received: from wolff.to ([65.117.131.163]:60000 "HELO wolff.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752948Ab1GLM4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 08:56:00 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Jul 2011 08:55:59 EDT
Date: Tue, 12 Jul 2011 07:34:10 -0500
From: Bruno Wolff III <bruno@wolff.to>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] sched: Fix 32bit race
Message-ID: <20110712123410.GA9067@wolff.to>
References: <1310472434.14978.27.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310472434.14978.27.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 14:07:14 +0200,
  Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> Ingo, can we get the below patch into sched/urgent and towards Linus
> before he cuts a release?
> 
> I'm surprised there weren't more 32bit-smp doesn't boot for me
> complaints, either Bruno is a very 'lucky' man, or nobody is using 32bit
> kernels any more since he was hitting this quite reliably.

On two different machines. Both an Athlon MP and an old Xeon were hitting
this problem on every boot.
