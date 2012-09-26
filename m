Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066Ab2IZPyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 11:54:20 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755760Ab2IZPyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 11:54:17 -0400
Date: Wed, 26 Sep 2012 17:54:13 +0200
From: Richard Weinberger <richard@nod.at>
To: artem.bityutskiy@linux.intel.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, Heinz.Egger@linutronix.de, tim.bird@am.sony.com
Subject: Re: [PATCH 01/10] UBI: Add fastmap on-flash data structures
Message-ID: <20120926175413.58a5c455@spider.haslach.nod.at>
In-Reply-To: <1348655591.24309.64.camel@sauron.fi.intel.com>
References: <1348511492-91606-1-git-send-email-richard@nod.at>
	<1348511492-91606-2-git-send-email-richard@nod.at>
	<1348655591.24309.64.camel@sauron.fi.intel.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem,

Am Wed, 26 Sep 2012 13:33:11 +0300
schrieb Artem Bityutskiy <artem.bityutskiy@linux.intel.com>:
> Richard, thanks, here is the deal I suggest
> 
> 1. I do not really have time to review this in details.
> 2. I do not want to block this either
> 3. I want to merge this to 3.7 with come pre-conditions (see below)
>    as "Experimental" with a claim that the on-flash format can
>    be changed. Something like Linus did for btrfs. Then let people
>    play with fastmap. I am sure it'll need changes when people
>    try to use it in production.
>    
>    a. Aiaiai is happy

sent you v19 where I've addresses all warnings from Aiaiai you mailed
me.

>    b. You provide a section for the mtd web site describing fastmap
>    c. It does not break anything when it is disabled
>    d. When it is enabled, it also passes the UBI tests
> 
> Actually, I want to expose it to linux-next already after step a.
> Despite a lot of testing you have already done, I am willing to do
> some testing myself as well, so I'll do c. and d. and let you know if
> there are issues.
> 
> Could you please do b. ?

Will do!
I'm fine with your plan.

Thanks,
//richard
