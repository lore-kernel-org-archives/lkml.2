Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab2A3ALd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 19:11:33 -0500
Received: from ozlabs.org ([203.10.76.45]:40710 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143Ab2A3ALc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 19:11:32 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: + kmod-avoid-deadlock-by-recursive-kmod-call.patch added to -mm tree
In-Reply-To: <20120129163141.GC20803@redhat.com>
References: <20120126175612.GA24011@redhat.com> <87ipjxdfbg.fsf@rustcorp.com.au> <20120127143234.GA13056@redhat.com> <87y5srbaf7.fsf@rustcorp.com.au> <20120129163141.GC20803@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 30 Jan 2012 09:56:44 +1030
Message-ID: <87aa56qedn.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jan 2012 17:31:41 +0100, Oleg Nesterov <oleg@redhat.com> wrote:
> Confused... in this case I do not understand why do you dislike the
> idea to kill khelper_wq.

Yes, you are confused.  I was agreeing with you:

 On Thu, 26 Jan 2012 18:56:12 +0100, Oleg Nesterov <oleg@redhat.com> wrote:
 > Can't we simply kill khelper_wq and use system_unbound_wq instead?

 I'd prefer that, because then we'd hit the existing "too many modprobes"
 check.

 Thanks,
 Rusty.

I thought "I'd prefer that" was pretty clear??

Thanks,
Rusty.
