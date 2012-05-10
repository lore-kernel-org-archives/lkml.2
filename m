Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab2EJHp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 03:45:29 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:56298 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756852Ab2EJHp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 03:45:27 -0400
Date: Thu, 10 May 2012 09:45:22 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Igor Mammedov <imammedo@redhat.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, pjt@google.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH] printk: Add %pb to print bitmaps
Message-ID: <20120510074522.GB28395@gmail.com>
References: <1336559908-32533-1-git-send-email-imammedo@redhat.com>
 <4FAA452A.1070909@gmail.com>
 <4FAA588B.5010404@redhat.com>
 <1336564330.2527.23.camel@twins>
 <4FAA5BFB.40309@redhat.com>
 <1336566096.2527.30.camel@twins>
 <1336566644.2527.33.camel@twins>
 <1336570043.2527.38.camel@twins>
 <20120509120745.042e86c6.akpm@linux-foundation.org>
 <1336597121.2527.74.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336597121.2527.74.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> > So perhaps it would be better to avoid consuming `b' for 
> > bitmaps?
> 
> With %.*pb not actually working I could use %pC to mean a 
> cpumask and skip the generic bitmap stuff.

I'd suggest to try that, all the objections came from trying to 
support variable size bitmaps. Lets just solve the scheduler 
bitmask problem and let others worry about the generic case?

You are trying to be too nice ;-)

Thanks,

	Ingo
