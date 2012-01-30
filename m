Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab2A3Moo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 07:44:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443Ab2A3Mon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 07:44:43 -0500
Date: Mon, 30 Jan 2012 13:38:19 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: + kmod-avoid-deadlock-by-recursive-kmod-call.patch added to
	-mm tree
Message-ID: <20120130123819.GA11414@redhat.com>
References: <20120126175612.GA24011@redhat.com> <87ipjxdfbg.fsf@rustcorp.com.au> <20120127143234.GA13056@redhat.com> <87y5srbaf7.fsf@rustcorp.com.au> <20120129163141.GC20803@redhat.com> <87aa56qedn.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87aa56qedn.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30, Rusty Russell wrote:
>
> On Sun, 29 Jan 2012 17:31:41 +0100, Oleg Nesterov <oleg@redhat.com> wrote:
> > Confused... in this case I do not understand why do you dislike the
> > idea to kill khelper_wq.
>
> Yes, you are confused.  I was agreeing with you:

Ah...

> I thought "I'd prefer that" was pretty clear??

It was! Looking back, I do not understand how did I manage to misread
your email.

Thanks Rusty,

Oleg.

