Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab0LASPY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:15:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876Ab0LASPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:15:23 -0500
Date: Wed, 1 Dec 2010 19:07:53 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        pageexec@freemail.hu, Solar Designer <solar@openwall.com>,
        Eugene Teo <eteo@redhat.com>, Brad Spengler <spender@grsecurity.net>,
        Roland McGrath <roland@redhat.com>, stable@kernel.org
Subject: Re: [PATCH 1/2] exec: make argv/envp memory visible to oom-killer
Message-ID: <20101201180753.GA6143@redhat.com>
References: <20101130195456.GA11905@redhat.com> <20101130195534.GB11905@redhat.com> <20101201090350.ABA2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101201090350.ABA2.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01, KOSAKI Motohiro wrote:
>
> > +static void acct_arg_size(struct linux_binprm *bprm, unsigned long pages)
>
> One minor request.
>
> I guess this function can easily makes confusing to a code reader. So I
> hope you write small function comments. describe to
>  - What is oom nascent issue
>  - Why we think inaccurate account is ok

Agreed, this needs a comment.

The patch was already applied, I'll send a separate one on top
of the next "unify exec/compat" series. Or, I'll add the comments
into this series, depending on review.

Thanks,

Oleg.

