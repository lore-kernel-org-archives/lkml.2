Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751278Ab1A1VXE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 16:23:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101Ab1A1VXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 16:23:02 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Tejun Heo <tj@kernel.org>
X-Fcc: ~/Mail/linus
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 06/10] signal: fix premature completion of group stop when interfered by ptrace
In-Reply-To: Tejun Heo's message of  Friday, 28 January 2011 16:08:40 +0100 <1296227324-25295-7-git-send-email-tj@kernel.org>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
	<1296227324-25295-7-git-send-email-tj@kernel.org>
Emacs: you'll understand when you're older, dear.
Message-Id: <20110128212257.9C18B183C1E@magilla.sf.frob.com>
Date: Fri, 28 Jan 2011 13:22:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It feels nasty to add a word to task_struct just for this.
I don't see another place to store such bookkeeping bits.
But I'm not entirely convinced that we'll really need them
when we conclude on fully cleaning up the whole picture.


Thanks,
Roland
