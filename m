Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab1JZEwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 00:52:00 -0400
Received: from ozlabs.org ([203.10.76.45]:41336 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446Ab1JZEv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 00:51:56 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dave Jones <davej@redhat.com>, Greg KH <greg@kroah.com>
Cc: Nick Bowler <nbowler@elliptictech.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Randy Dunlap <rdunlap@xenotime.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>,
        Roland Vossen <rvossen@broadcom.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH] module,bug: Add TAINT_OOT_MODULE flag for modules not built in-tree
In-Reply-To: <20111025201723.GA25063@redhat.com>
References: <1319461948.31243.31.camel@deadeye> <4EA57CBF.2050901@xenotime.net> <87k47tpvvm.fsf@rustcorp.com.au> <20111025153855.GA24779@elliptictech.com> <1319558749.11727.6.camel@deadeye> <20111025165142.GA25354@elliptictech.com> <20111025200455.GA6376@kroah.com> <20111025201723.GA25063@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 26 Oct 2011 14:46:44 +1030
Message-ID: <87zkgoo09f.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Oct 2011 16:17:24 -0400, Dave Jones <davej@redhat.com> wrote:
> commit 7816c45bf13255157c00fb8aca86cb64d825e878
> Author: Roland Vossen <rvossen@broadcom.com>
> Date:   Thu Apr 7 11:20:58 2011 +0200
> 
>     modules: Enabled dynamic debugging for staging modules
...
>     
>     Signed-off-by: Roland Vossen <rvossen@broadcom.com>
>     Acked-by: Jason Baron <jbaron@redhat.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Greg, you know better.  This is why we have maintainers: I can't track
patches I don't see.  Grrr...

> If we want to support out of tree modules with this, should we just nuke the
> whole check, or do we still want to prevent certain types of tainted kernels
> from using this stuff ?

It goes back to the first implementation of kernel markers.  IIRC, it
was to prevent dynamic debug stuff from circumventing licensing, but
testing for *any* taint seems overbroad.  Mathieu?

Thanks,
Rusty.
PS.  Can't see how this related to lockdep either...
