Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab1JaGn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 02:43:26 -0400
Received: from ozlabs.org ([203.10.76.45]:37322 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974Ab1JaGnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 02:43:25 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ben Hutchings <ben@decadent.org.uk>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>
Cc: Nick Bowler <nbowler@elliptictech.com>, Greg KH <greg@kroah.com>,
        Dave Jones <davej@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>
Subject: Re: [PATCH 1/2] lockdep,rtmutex,bug: Show taint flags on error
In-Reply-To: <1319773015.6759.30.camel@deadeye>
References: <1319773015.6759.30.camel@deadeye>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 31 Oct 2011 12:29:43 +1030
Message-ID: <87lis1q5tc.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Oct 2011 04:36:55 +0100, Ben Hutchings <ben@decadent.org.uk> wrote:
> Currently lock debugging is disabled when the kernel is tainted, with
> a few exceptions.  It is already recognised that this can be useful
> for staging modules (TAINT_CRAP), but that also goes for out-of-tree
> modules (TAINT_OOT_MODULE) so long as core kernel developers don't
> have to spend time debugging them.  Also, there are several reasons
> for tainting that are unlikely to introduce false locking bug reports
> (e.g. TAINT_FIRMWARE_WORKAROUND).
> 
> Instead of disabling lock debugging, show the taint flags in all
> lockdep and rtmutex-debug error messages.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

Acked-by: Rusty Russell <rusty@rustcorp.com.au>
