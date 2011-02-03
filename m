Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab1BCVwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 16:52:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888Ab1BCVwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 16:52:46 -0500
Date: Thu, 3 Feb 2011 22:44:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110203214450.GA29496@redhat.com>
References: <1296227324-25295-1-git-send-email-tj@kernel.org> <1296227324-25295-11-git-send-email-tj@kernel.org> <20110203204122.GA26371@redhat.com> <20110203204154.GB26371@redhat.com> <20110203213640.1F516180995@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110203213640.1F516180995@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03, Roland McGrath wrote:
>
> IMHO this sort of band-aid does not really help the overall situation.
> It takes something that is intricate and fiddly and just fiddles it a
> bit more.  Userland will still have to handle older kernels where this
> behavior is not there.  If userland does anything that relies on this
> new behavior, then it will have to try somehow to figure out which
> kernel versions have which behavior and adapt, etc.

Absolutely agreed.

As I said, I am not sure this patch makes sense. I only sent it
because I have to react to the bug report.

> When the old behaviors are unhelpful like this, I think it is really
> better to add new mechanisms instead.

Agreed!

Can't resist, let me repeat... imho ptrace is unfixable ;)


OK, please ignore this patch.

Oleg.

