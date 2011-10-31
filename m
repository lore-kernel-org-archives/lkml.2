Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab1JaGn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 02:43:27 -0400
Received: from ozlabs.org ([203.10.76.45]:35614 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026Ab1JaGnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 02:43:25 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dave Jones <davej@redhat.com>
Cc: Nick Bowler <nbowler@elliptictech.com>, Greg KH <greg@kroah.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Randy Dunlap <rdunlap@xenotime.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH] module,bug: Add TAINT_OOT_MODULE flag for modules not built in-tree
In-Reply-To: <20111027015528.GA19696@redhat.com>
References: <4EA57CBF.2050901@xenotime.net> <87k47tpvvm.fsf@rustcorp.com.au> <20111025153855.GA24779@elliptictech.com> <1319558749.11727.6.camel@deadeye> <20111025165142.GA25354@elliptictech.com> <20111025200455.GA6376@kroah.com> <20111025201723.GA25063@redhat.com> <20111025205410.GA7479@kroah.com> <20111026130834.GA6387@elliptictech.com> <874nyvnsqe.fsf@rustcorp.com.au> <20111027015528.GA19696@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 31 Oct 2011 12:00:10 +1030
Message-ID: <87zkgiosm5.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Oct 2011 21:55:28 -0400, Dave Jones <davej@redhat.com> wrote:
> On Thu, Oct 27, 2011 at 11:41:37AM +1030, Rusty Russell wrote:
> 
>  > I think we need a "taint_string()" function, and instead of lockdep
>  > disabling itself it should note the taint string in its reports.
>  > Similarly for anything else (oops already does this).
> 
> you mean like print_tainted() ?

Wow, there's one terribly named function!

So, yeah, kinda like that.  Only remove the suckage.

Thanks,
Rusty.
