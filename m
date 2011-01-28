Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab1A1VKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 16:10:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753312Ab1A1VKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 16:10:30 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Tejun Heo <tj@kernel.org>
X-Fcc: ~/Mail/linus
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 04/10] ptrace: kill tracehook_notify_jctl()
In-Reply-To: Tejun Heo's message of  Friday, 28 January 2011 16:08:38 +0100 <1296227324-25295-5-git-send-email-tj@kernel.org>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
	<1296227324-25295-5-git-send-email-tj@kernel.org>
X-Zippy-Says: Somewhere in DOWNTOWN BURBANK a prostitute is OVERCOOKING a LAMB CHOP!!
Message-Id: <20110128210953.80F1B183C1E@magilla.sf.frob.com>
Date: Fri, 28 Jan 2011 13:09:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm OK with this one if Oleg is.  I'll leave it up to him.  What's good
about the tracehook functions is that they clearly specify the semantics
and the assumptions in their kerneldoc comments.  It's ok to change things
around and have some fur flying while we clean things up.  But we really
should get back to a situation where the semantics and the logic of the
code are clearly documented, and we don't have implementation details and
ptrace user ABI semantics jumbled together implicitly in code that doesn't
explain what it all means.


Thanks,
Roland
