Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab1BBFcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 00:32:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539Ab1BBFcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 00:32:19 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Tejun Heo <tj@kernel.org>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH] ptrace: use safer wake up on ptrace_detach()
In-Reply-To: Tejun Heo's message of  Tuesday, 1 February 2011 16:07:27 +0100 <20110201150727.GP14211@htj.dyndns.org>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
	<1296227324-25295-3-git-send-email-tj@kernel.org>
	<20110128184601.CBF7C180996@magilla.sf.frob.com>
	<20110131103855.GD7459@htj.dyndns.org>
	<20110201102618.GE14211@htj.dyndns.org>
	<20110201134037.GA25392@redhat.com>
	<20110201150727.GP14211@htj.dyndns.org>
X-Shopping-List: (1) Sarcastic lotion
   (2) Scratch 'n' Snot Whips
   (3) Nonsensical fermented bacon losers
   (4) Lustrous laughter
Message-Id: <20110202053144.29748183D88@magilla.sf.frob.com>
Date: Tue,  1 Feb 2011 21:31:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Oleg, Roland, you guys are the maintainers, so how do you guys want to
> route the patches which have been acked?  As it's likely that there
> will be quite some number of ptrace patches, it will be better to have
> a git tree.

In practice we are never trusted enough with changes in this area to get
them just pulled from a tree of ours.  They have to go through akpm and
Linus for individual approval before they get in.  So I see no point in me
or Oleg maintaining a git tree that won't get merged directly anyway.


Thanks,
Roland
