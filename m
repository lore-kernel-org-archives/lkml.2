Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab1LTBmb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 20:42:31 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:35680 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab1LTBma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 20:42:30 -0500
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
        bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 4/4] sched:Implement set_gang_buddy
In-Reply-To: <1324309908.24621.16.camel@twins>
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com> <20111219083504.32311.85836.stgit@abhimanyu.in.ibm.com> <1324309908.24621.16.camel@twins>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Tue, 20 Dec 2011 07:13:03 +0530
Message-ID: <87bor42f2w.fsf@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 11121915-5490-0000-0000-0000005FD412
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
Experimenting ;)

/me runs

