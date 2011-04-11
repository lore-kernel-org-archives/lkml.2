Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab1DKRVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 13:21:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732Ab1DKRVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 13:21:13 -0400
Date: Mon, 11 Apr 2011 19:19:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/6] signal: sigprocmask fixes
Message-ID: <20110411171957.GA32469@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am not sure this is really wrong and should be fixed. Please comment.

1-2: probably make sense anyway, cleanup + optimization.

4: the main change. From the changelog,

	In short, almost every changing of current->blocked is wrong,
	or at least can lead to the unexpected results.

5-6: If this should be fixed, then we need a lot more trivial changes
     like these ones.

What do you all think?


In theory this can explain the hang reported by Nikita, but this is
not clear.

Oleg.

