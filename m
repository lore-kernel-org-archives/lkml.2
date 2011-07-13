Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab1GMXl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 19:41:59 -0400
Received: from mail.perches.com ([173.55.12.10]:3992 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512Ab1GMXl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 19:41:58 -0400
Subject: Re: [PATCH] checkpatch.pl: Update $logFunctions
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, Kalle Valo <kvalo@qca.qualcomm.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110713161640.83199c0b.akpm@linux-foundation.org>
References: <02ca5948a9627c6f4c2ab2b502f114623839c6fe.1310572985.git.joe@perches.com>
	 <20110713161640.83199c0b.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jul 2011 16:41:56 -0700
Message-ID: <1310600516.1662.43.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-13 at 16:16 -0700, Andrew Morton wrote:
> On Wed, 13 Jul 2011 09:05:47 -0700
> Joe Perches <joe@perches.com> wrote:
> > Allow numbers in leading prefix.
> > Add logging functions with _once and _ratelimit.
> > Add <prefix>_printk.
> I look at this description wondering "hm, what does this do to
> checkpatch behaviour" and realize I have not a clue.
> Oh well, I'll trust you ;)

Not necessarily a good plan...

Perhaps this description instead:

[PATCH] checkpatch.pl: Allow more printk types (<prefix>_<level>) to be > 80 cols

Previous behavior allowed only alphabetic prefixes
like pr_info to exceed the 80 column line length limit.

ath6kl wants to add a digit into the prefix, so allow
numbers as well as digits in the <prefix>_<level> printks.

<prefix>_<level>_ratelimited and <prefix>_<level>_once
and WARN_RATELIMIT and WARN_ONCE may now exceed 80 cols.

Add missing <prefix>_printk type for completeness.

