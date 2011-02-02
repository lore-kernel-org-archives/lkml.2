Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab1BBFdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 00:33:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539Ab1BBFdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 00:33:35 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Tejun Heo <tj@kernel.org>, oleg@redhat.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] ptrace: use safer wake up on ptrace_detach()
In-Reply-To: Andrew Morton's message of  Tuesday, 1 February 2011 16:27:29 -0800 <20110201162729.f75be47d.akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
	<1296227324-25295-3-git-send-email-tj@kernel.org>
	<20110128184601.CBF7C180996@magilla.sf.frob.com>
	<20110131103855.GD7459@htj.dyndns.org>
	<20110201102618.GE14211@htj.dyndns.org>
	<20110201162729.f75be47d.akpm@linux-foundation.org>
X-Shopping-List: (1) Automated scurrilous proportion brides
   (2) Contagious detrimental goats
   (3) Spontaneous callous pollution pencils
   (4) Humorous suicide snoozeers
Message-Id: <20110202053331.C27C6183D88@magilla.sf.frob.com>
Date: Tue,  1 Feb 2011 21:33:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Am unable to work out why you tagged it for backporting.  It fixes some
> observed bug?  Perhaps a regression?

No observed bug, only theoretical ones (AFAIK, never even a ginned-up
synthetic test case has been demonstrated).  Certainly not a regression,
since it has been this (wrong) way since the dawn of time.  I don't think
this first change is dangerous for -stable, but I have seen no positive
rationale for pushing it there.


Thanks,
Roland
