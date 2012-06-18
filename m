Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208Ab2FRNdy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 09:33:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab2FRNdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 09:33:53 -0400
Date: Mon, 18 Jun 2012 09:33:05 -0400
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: baryluk@smp.if.uj.edu.pl, LKML <linux-kernel@vger.kernel.org>,
        JBeulich@suse.com, zhong@linux.vnet.ibm.com
Subject: Re: [PATCH 0/2] x86,nmi: Section header fixes
Message-ID: <20120618133305.GU32472@redhat.com>
References: <1339428809-29360-1-git-send-email-dzickus@redhat.com>
 <20120618090731.GC28824@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120618090731.GC28824@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 11:07:31AM +0200, Ingo Molnar wrote:
> 
> * Don Zickus <dzickus@redhat.com> wrote:
> 
> > An earlier attempt at a fix for the problem described in the second patch was
> > committed to Ingo's tree.  Later a smaller/cleaner patch was posted.  This
> > series just reverts the original patch and then applies the second patch.
> > 
> > The second patch looks a lot cleaner this way instead of just provding the
> > delta patch on top.
> > 
> > Ingo, let me know if this is not what you want.
> 
> Wouldnt this be nicer as a delta enhancement, instead of a 
> revert+fix-done-differently?
> 
> That way we'd should that the original one was good as well, 
> it's just that this one is easier to maintain.

Ok.  I originally had a delta diff, but it looked ugly and hard to
understand the new changes.  That is why I did it this way.  I'll send the
delta enhancement and let you decide.

Cheers,
Don
