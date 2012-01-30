Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab2A3AZS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 19:25:18 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37521 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab2A3AZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 19:25:16 -0500
Date: Sun, 29 Jan 2012 16:25:11 -0800
From: Tejun Heo <tj@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: + kmod-avoid-deadlock-by-recursive-kmod-call.patch added to -mm
 tree
Message-ID: <20120130002511.GF17211@htj.dyndns.org>
References: <20120126175612.GA24011@redhat.com>
 <87ipjxdfbg.fsf@rustcorp.com.au>
 <20120127143234.GA13056@redhat.com>
 <87y5srbaf7.fsf@rustcorp.com.au>
 <20120129163141.GC20803@redhat.com>
 <87aa56qedn.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87aa56qedn.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 09:56:44AM +1030, Rusty Russell wrote:
> On Sun, 29 Jan 2012 17:31:41 +0100, Oleg Nesterov <oleg@redhat.com> wrote:
> > Confused... in this case I do not understand why do you dislike the
> > idea to kill khelper_wq.
> 
> Yes, you are confused.  I was agreeing with you:
> 
>  On Thu, 26 Jan 2012 18:56:12 +0100, Oleg Nesterov <oleg@redhat.com> wrote:
>  > Can't we simply kill khelper_wq and use system_unbound_wq instead?

BTW, why does it have to be unbound_wq?  Is it expected consume large
amount of CPU cycles?

Thanks.

-- 
tejun
