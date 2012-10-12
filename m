Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab2JLWSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 18:18:53 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36816 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab2JLWSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 18:18:51 -0400
Date: Fri, 12 Oct 2012 23:18:43 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dl8bcu@dl8bcu.de, peterz@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/1] (Was: [regression] boot failure on alpha, bisected)
Message-ID: <20121012221843.GJ2616@ZenIV.linux.org.uk>
References: <20121006204736.GA1830@ds20.borg.net>
 <20121012160337.GA30881@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121012160337.GA30881@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 06:03:37PM +0200, Oleg Nesterov wrote:
> On 10/06, Thorsten Kranzkowski wrote:
> >
> > After upgrading from v3.5-rc7 to current git my system oopses and locks up
> > early in the boot sequence.
> 
> OK, I am sending the patch which I already showed.
> 
> Perhaps we should only add the warning and local_irq_enable()
> should go into arch/alpha/kernel/signal.c:do_notify_resume().
> 
> In any case arch/alpha/ should be fixed imho.

Oleg, could you check current signal.git#for-next?  alpha patches in
there ought to deal with the do_notify_resume() mess on alpha
for good, AFAICS.
