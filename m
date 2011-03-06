Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab1CFRLL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 12:11:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726Ab1CFRLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 12:11:06 -0500
Date: Sun, 6 Mar 2011 18:01:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        pageexec@freemail.hu, Solar Designer <solar@openwall.com>,
        Eugene Teo <eteo@redhat.com>, Brad Spengler <spender@grsecurity.net>,
        Roland McGrath <roland@redhat.com>, Milton Miller <miltonm@bga.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH v5 0/4] exec: unify native/compat code
Message-ID: <20110306170156.GA24175@redhat.com>
References: <AANLkTimp=mhedXLdrZFqK2QWYvg7MdmUPj3-Q9m2vtTx@mail.gmail.com> <20110305203040.GA7546@redhat.com> <20110306210334.6CD5.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110306210334.6CD5.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06, KOSAKI Motohiro wrote:
>
> And, I happily reported this series run successfully my testsuite.
> Could you please add my tested-by tag?

Sure, thanks a lot Kosaki.

I hope this is the last version. Changes:

	- as Linus pointed out, we do not have compat_uptr_t without
	  CONFIG_COMPAT. Add another ifdef into struct user_arg_ptr.

Oleg.

