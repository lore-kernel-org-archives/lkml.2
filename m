Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933485Ab2JLH4O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 03:56:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:33310 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933061Ab2JLH4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 03:56:12 -0400
Message-ID: <1350028557.20486.154.camel@pasglop>
Subject: Re: [git pull] signal.git, pile 2 (was Re: [RFC][CFT][CFReview]
 execve and kernel_thread unification work)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        linux-arch@vger.kernel.org, David Miller <davem@davemloft.net>
Date: Fri, 12 Oct 2012 18:55:57 +1100
In-Reply-To: <20121012010958.GG2616@ZenIV.linux.org.uk>
References: <20121001213809.GA31155@ZenIV.linux.org.uk>
	 <20121011090023.GA28427@bloggs.ozlabs.ibm.com>
	 <20121011125306.GF2616@ZenIV.linux.org.uk>
	 <20121012001633.GA29883@bloggs.ozlabs.ibm.com>
	 <20121012010958.GG2616@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-12 at 02:09 +0100, Al Viro wrote:
> Anyway, if ppc folks can live with that stuff in its current form for now,
> here's the second signal.git pull request.  Stuff in there: kernel_thread/
> kernel_execve/sys_execve conversions for several more architectures plus
> assorted signal fixes and cleanups.  There'll be more (in particular, real
> fixes for alpha do_notify_resume() irq mess)...  Linus, could you pull that
> queue?  It's in the usual place -
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal for-linus

Yes, we can live with what's in there, it won't break anything. We can
do the proposed cleanups subsequently.

Cheers,
Ben.


