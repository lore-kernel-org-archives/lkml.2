Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab2GIJMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 05:12:54 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61546 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab2GIJMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 05:12:53 -0400
Date: Mon, 9 Jul 2012 11:12:47 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] uprobes: write_opcode() cleanups
Message-ID: <20120709091247.GB2901@gmail.com>
References: <20120624145936.GA23269@redhat.com>
 <20120706105425.GA31587@gmail.com>
 <20120706160704.GA8499@redhat.com>
 <20120706161303.GA8956@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120706161303.GA8956@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> On 07/06, Oleg Nesterov wrote:
> >
> > On 07/06, Ingo Molnar wrote:
> > >
> > > * Oleg Nesterov <oleg@redhat.com> wrote:
> > >
> > > > Hello,
> > > >
> > > > write_opcode() cleanups resend + new minor fix.
> > > >
> > > > Changes:
> > > >
> > > > 	- document the new argument in 2/5.
> > > >
> > > > 	- drop the buggy 5/5, thanks Anton for your quick nack.
> > > > 	  Probably I'll return to this later, I have another reason
> > > > 	  for this change.
> > > >
> > > > 	- so this 5/5 is new.
> > > >
> > > > Srikar, please add your acks unless you have some objections.
> > >
> > > Just wondering what's the review status of patches #1-#4?
> >
> > I hope Srikar will ack 1-4 soon.
> >
> > He observed the testing failures, but it turns out this series
> > is innocent.
> >
> > I'll send more fixes soon.
> >
> > > I'll skip #5 based on Oleg's request,
> >
> > Yes, thanks. I still think 5/5 makes sense, but we need to do
> > something with uprobe.s:vma_address() first.
> 
> Argh.
> 
> I wrote this email because I wanted to say that I updated the
> changelog for 2/5 a little bit, but forgot to mention this.
> I'll send the updated patch in reply to 2/5 (once again, only
> the changelog was changed). But please let me know if you want
> me to resend 1-4.

Once Srikar's ack is in then it would be nice to update the 
patches with the ack and resend #1-#4, to make sure I have all 
the intended patches and nothing more or less than that.

Thanks,

	Ingo
