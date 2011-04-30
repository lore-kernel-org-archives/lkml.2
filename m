Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab1D3Mv4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 08:51:56 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59247 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756534Ab1D3Mvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 08:51:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VdTf5kxQrrWz3SyWI9G3/yNr0keM1pmPecKVIizO5/yKYvHTrfMv+IvME8SwXkk7mr
         /wgaORdkExOw+zKa0G5sK9J24HKuIDR9q3d8+zVcCbQUJExgOo+sYVloxBfdWBAj1/zR
         ZbnywTbZUoek+z8aIdVj+BQBkCpzykCUdZotE=
Date: Sat, 30 Apr 2011 14:51:48 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] signals-review branch
Message-ID: <20110430125148.GI29280@htj.dyndns.org>
References: <20110418134421.GA15951@redhat.com>
 <20110418134501.GC15951@redhat.com>
 <20110425105229.GE17734@mtj.dyndns.org>
 <20110425152040.GA14934@redhat.com>
 <20110425161951.GA30828@mtj.dyndns.org>
 <20110425170200.GA18363@redhat.com>
 <BANLkTi=oksQFYtyS1+RA5c_4E22yjik90g@mail.gmail.com>
 <20110426194536.GA7590@redhat.com>
 <20110428152613.GA14174@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110428152613.GA14174@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 05:26:13PM +0200, Oleg Nesterov wrote:
> I collected the patches which were acked by Tejun and Matt and (I hope)
> Linus agrees with,
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc.git signals-review
> 
> 	[PATCH 01/13] signal: introduce retarget_shared_pending()
> 	[PATCH 02/13] signal: retarget_shared_pending: consider shared/unblocked signals only
> 	[PATCH 03/13] signal: retarget_shared_pending: optimize while_each_thread() loop
> 	[PATCH 04/13] signal: sigprocmask: narrow the scope of ->siglock
> 	[PATCH 05/13] signal: sigprocmask() should do retarget_shared_pending()
> 	[PATCH 06/13] x86: signal: handle_signal() should use set_current_blocked()
> 	[PATCH 07/13] x86: signal: sys_rt_sigreturn() should use set_current_blocked()
> 	[PATCH 08/13] signal: cleanup sys_rt_sigprocmask()
> 	[PATCH 09/13] signal: sys_rt_sigtimedwait: simplify the timeout logic
> 	[PATCH 10/13] signal: introduce do_sigtimedwait() to factor out compat/native code
> 	[PATCH 11/13] signal: do_sigtimedwait() needs retarget_shared_pending()
> 	[PATCH 12/13] signal: rename signandsets() to sigandnsets()
> 	[PATCH 13/13] signal: cleanup sys_sigprocmask()

Looks all fine to me.  I'll base further patches on top of these.

Thanks.

-- 
tejun
