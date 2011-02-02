Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab1BBVsz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 16:48:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049Ab1BBVsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 16:48:54 -0500
Date: Wed, 2 Feb 2011 22:40:59 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH] ptrace: use safer wake up on ptrace_detach()
Message-ID: <20110202214059.GA18698@redhat.com>
References: <1296227324-25295-1-git-send-email-tj@kernel.org> <1296227324-25295-3-git-send-email-tj@kernel.org> <20110128184601.CBF7C180996@magilla.sf.frob.com> <20110131103855.GD7459@htj.dyndns.org> <20110201102618.GE14211@htj.dyndns.org> <20110201162729.f75be47d.akpm@linux-foundation.org> <20110202053331.C27C6183D88@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110202053331.C27C6183D88@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01, Roland McGrath wrote:
>
> > Am unable to work out why you tagged it for backporting.  It fixes some
> > observed bug?  Perhaps a regression?
>
> No observed bug,

Well, this bug triggered the problem in practice, this was the reason
for 95a3540d.

> I don't think
> this first change is dangerous for -stable, but I have seen no positive
> rationale for pushing it there.

Agreed, I don't really think -stable needs this change, but otoh
it is obviously safe.

Oleg.

