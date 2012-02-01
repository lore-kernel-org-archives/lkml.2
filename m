Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab2BAHqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 02:46:39 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:56497 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab2BAHqh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 02:46:37 -0500
Date: Wed, 01 Feb 2012 02:43:57 -0500 (EST)
Message-Id: <20120201.024357.1370213516985704222.davem@davemloft.net>
To: steweg@ynet.sk
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v7, kernel version 3.2.1] net/ipv4/ip_gre: Ethernet
 multipoint GRE over IP
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAGsizzKB=NcAe9KvfZbbPiGvSQ6a9Mj+kBaKtDQziGWJ+eGGRA@mail.gmail.com>
References: <CAGsizzLTHw5Ja3kT-zEN8uK5GrzpmN1bxOhA0OscGL5R6tH3WA@mail.gmail.com>
	<20120131.190830.1189531706541596294.davem@davemloft.net>
	<CAGsizzKB=NcAe9KvfZbbPiGvSQ6a9Mj+kBaKtDQziGWJ+eGGRA@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 31 Jan 2012 23:44:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ¦tefan Gula <steweg@ynet.sk>
Date: Wed, 1 Feb 2012 08:22:02 +0100

> So if this is now only about the
> maintenance of my code, I'll be more than happy to continue
> maintaining it myself together with you guys.

You have a very warped understanding of what maintainence cost means.

Everyone time someone wants to change a core API in the networking
your new code will need to be considered.  Every time someone wants to
audit how an interface is used, your code adds to the audit burdon.

And this is burdon placed upon other people, even if you personally
"promise" to maintain this specific code snippet.  This promise
completely meaningless from a global kernel maintainence standpoint.

More code has a cost, no matter how well that specific piece of code
is maintained.

Therefore we don't add supurious code, and your code is spurious if it
will end up duplicating a more desirable implementation and interface
for this functionality.

The world has spun successfully countless times in the 18 years that
Linux hasn't had support for the feature you are so gravely interested
in including "right now", and I suspect it will spin successfully a
few more times while a proper implementation is ironed out.
