Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760906Ab2DKSxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 14:53:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756933Ab2DKSxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 14:53:40 -0400
Date: Wed, 11 Apr 2012 20:52:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] creds: kill __task_cred()->task_is_dead()
	validation
Message-ID: <20120411185252.GC22543@redhat.com>
References: <20120410194554.GA7196@redhat.com> <20120410194625.GB7196@redhat.com> <m1obqyh960.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1obqyh960.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> A small nit.  The subject should be:
> "Remove task_is_dead from __task_cred() validation."
> there is no method __task_cred()->task_is_dead().

I often use this notation to show the caller and the callee,
but I don't really mind.

> > Unfortunately, we can't kill task_is_dead() right now, it has already
> > found the bugy users in drivers/staging/, the fix already exists.
>
> I would say task_is_dead() has already acquired buggy users in
> drivers/staging.

Argh, it least I shouldn't have said "bugy".

> As for the patch itself, and the direction of removing task_is_dead().
> It looks good from where I sit.
>
> Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>

Thanks! I'll fix the subject/changelog and resend with your and
David's acks.

Oleg.

