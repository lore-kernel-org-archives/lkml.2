Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab1AaQCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 11:02:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23447 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020Ab1AaQCC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 11:02:02 -0500
Date: Mon, 31 Jan 2011 16:54:11 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCHSET RFC] ptrace,signal: clean transition between STOPPED
	and TRACED
Message-ID: <20110131155411.GA1613@redhat.com>
References: <1293199257-11255-1-git-send-email-tj@kernel.org> <20110118021417.D347A1807B7@magilla.sf.frob.com> <20110127154600.GE24925@htj.dyndns.org> <20110127174857.GG24925@htj.dyndns.org> <20110128204030.52D31183C1E@magilla.sf.frob.com> <20110131154117.GK7459@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110131154117.GK7459@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31, Tejun Heo wrote:
>
> Hello,
>
> On Fri, Jan 28, 2011 at 12:40:30PM -0800, Roland McGrath wrote:
> > > Okay, just finished ran make check with and without the patchset.
> > > Without the patchset, 2.6.38-rc2 failed five tests.
> >
> > Hmm.  I didn't think we were in that poor a state, but it has been quite a
> > while since I looked.  I wonder if that's a regression from a few releases
> > back, or what.  Oleg and Jan should know better than I do about the state
> > of these tests.
>
> Also, the first test of xcheck seems to enter infinite loop.

Are you sure late-ptrace-may-attach-check hangs? Perhaps it is the next
one, tracer-lockup-on-sighandler-kill, it needs a lot of time to finish.
IIRC, some time ago I did the testing with your patches applied (under
kvm), I didn't notice anything unexpected.

Unfortunately, these tests are more or less "random", usually a new
test-case appears when we find a bug.

Oleg.

