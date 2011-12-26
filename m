Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab1LZCes (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Dec 2011 21:34:48 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:35414 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558Ab1LZCel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Dec 2011 21:34:41 -0500
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
        bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 4/4] sched:Implement set_gang_buddy
In-Reply-To: <1324309908.24621.16.camel@twins>
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com> <20111219083504.32311.85836.stgit@abhimanyu.in.ibm.com> <1324309908.24621.16.camel@twins>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Mon, 26 Dec 2011 08:00:23 +0530
Message-ID: <87y5u0t680.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 11122516-0260-0000-0000-0000004BBE14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Dec 2011 16:51:48 +0100, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2011-12-19 at 14:05 +0530, Nikunj A. Dadhania wrote:
> > +       /*
> > +        * Gang buddy, lets be unfair here
> > +        */ 
> 
> And why would you think that's an option?
> 
Long answer, my previous experiments with set_next_buddy showed that the
gang groups were getting lesser cpu bandwidth than the baseline. Then I
thought of having a new helper(set_gang_buddy) that would give better
chance to gang sched tasks. This will only be affecting the following
cpus.  In the cpu, which has gang_leader set, the code is not giving
undue advantage to the gang task.

Regards,
Nikunj

