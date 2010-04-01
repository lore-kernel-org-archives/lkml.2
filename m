Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818Ab0DAUC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 16:02:56 -0400
Received: from www.tglx.de ([62.245.132.106]:53975 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758807Ab0DAUCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 16:02:52 -0400
Date: Thu, 1 Apr 2010 22:01:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chase Douglas <chase.douglas@canonical.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel-team <kernel-team@lists.ubuntu.com>
Subject: Re: [REGRESSION 2.6.30][PATCH 1/1] sched: defer idle accounting till
 after load update period
In-Reply-To: <z2i40ec3ea41004011256p281cc601t277c3191fef5f87b@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1004012200340.32352@localhost.localdomain>
References: <1269870072-22449-1-git-send-email-chase.douglas@canonical.com>  <1269870072-22449-2-git-send-email-chase.douglas@canonical.com>  <20100401122740.a1ae80a7.akpm@linux-foundation.org>
 <z2i40ec3ea41004011256p281cc601t277c3191fef5f87b@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Apr 2010, Chase Douglas wrote:
> On Thu, Apr 1, 2010 at 3:27 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> Thomas Gleixner seems to think this isn't the best approach (later
> email in this thread), so I'm deferring sending it unless someone is
> still interested in this approach.

Well, it's a good workaround for now I think, I just answered Andrews
question whether we can't do any better :)

Thanks,

	tglx
