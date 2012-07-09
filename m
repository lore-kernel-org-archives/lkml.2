Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab2GIK2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 06:28:21 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41636 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056Ab2GIK2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 06:28:19 -0400
Date: Mon, 9 Jul 2012 15:57:42 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] uprobes: write_opcode() cleanups
Message-ID: <20120709102742.GB32393@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120624145936.GA23269@redhat.com>
 <20120706105425.GA31587@gmail.com>
 <20120706160704.GA8499@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120706160704.GA8499@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12070910-8974-0000-0000-00000AFB389C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-07-06 18:07:04]:

> On 07/06, Ingo Molnar wrote:
> >
> > * Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > > Hello,
> > >
> > > write_opcode() cleanups resend + new minor fix.
> > >
> > > Changes:
> > >
> > > 	- document the new argument in 2/5.
> > >
> > > 	- drop the buggy 5/5, thanks Anton for your quick nack.
> > > 	  Probably I'll return to this later, I have another reason
> > > 	  for this change.
> > >
> > > 	- so this 5/5 is new.
> > >
> > > Srikar, please add your acks unless you have some objections.
> >
> > Just wondering what's the review status of patches #1-#4?
> 
> I hope Srikar will ack 1-4 soon.
> 
> He observed the testing failures, but it turns out this series
> is innocent.
> 


The 1st patch in your series, seems to have solved the problem.
I am not able to reproduce the problem for now .. Will keep running for
some time.


I will send out the acks for each of the patches in these series now.

-- 
Thanks and Regards
Srikar

