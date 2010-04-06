Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab0DFOJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 10:09:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37094 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab0DFOJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 10:09:13 -0400
Subject: Re: [PATCH V2 0/6][RFC] futex: FUTEX_LOCK with optional adaptive
 spinning
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Darren Hart <dvhltc@us.ibm.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "Peter W. Morreale" <pmorreale@novell.com>,
       Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <4BBB3A15.6020502@redhat.com>
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com>
	 <4BBA5305.7010002@redhat.com> <4BBA5C00.4090703@us.ibm.com>
	 <4BBA6279.20802@redhat.com> <4BBA6B6F.7040201@us.ibm.com>
	 <4BBB36FA.4020008@redhat.com> <1270560931.1595.342.camel@laptop>
	 <4BBB3A15.6020502@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Apr 2010 16:09:08 +0200
Message-ID: <1270562948.1595.442.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-06 at 16:41 +0300, Avi Kivity wrote:
> On 04/06/2010 04:35 PM, Peter Zijlstra wrote:
> > On Tue, 2010-04-06 at 16:28 +0300, Avi Kivity wrote:
> >    
> >> Yes, but that's the best case for spinning.  You could simply use a
> >> userspace spinlock in this case.
> >>      
> > Userspace spinlocks are evil.. they should _never_ be used.
> >    
> 
> But in this case they're fastest.  If we don't provide a non-evil 
> alternative, people will use them.
> 

That's what FUTEX_LOCK is about.

