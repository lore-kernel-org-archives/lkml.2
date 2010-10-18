Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647Ab0JRO7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:59:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:54407 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159Ab0JRO7O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:59:14 -0400
Subject: Re: [PATCH] checkpatch: allow single space before labels
From: Peter Zijlstra <peterz@infradead.org>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Mike Frysinger <vapier@gentoo.org>, Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20101018145400.GD4120@thunk.org>
References: <1287302737-3507-1-git-send-email-vapier@gentoo.org>
	 <1287303678.20968.37.camel@Joe-Laptop>
	 <AANLkTimmSRS3eVsW4EZUxnE_rfjeqmmgGnjtWbn3J_nY@mail.gmail.com>
	 <1287310889.1998.153.camel@laptop> <1287334498.20968.53.camel@Joe-Laptop>
	 <1287343839.1998.699.camel@laptop>
	 <AANLkTikaxf-Fh9qUxsXNO5=r+SoxbzYXvCjFcHQLcXjy@mail.gmail.com>
	 <1287345710.1998.735.camel@laptop>
	 <AANLkTimixEGQTYrM7ShodtKeC97e0uPNRhWQn8F+-Nui@mail.gmail.com>
	 <20101018143935.GA4120@thunk.org>  <20101018145400.GD4120@thunk.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 18 Oct 2010 16:58:53 +0200
Message-ID: <1287413933.29097.1608.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-18 at 10:54 -0400, Ted Ts'o wrote:
> Note that there is absolutely nothing about how labels should be
> indented in CodingStyle at all, and I very much resist code
> straightjackets being imposed by checkpatch.pl implementors.
> 
> Can we please stop this nonsense? 

1) ignoring checkpatch over taste is good
2) by 1) its impossible to get checkpatch right
3) therefore pure checkpatch patches are nonsense

So can we agree that checkpatch is ok in its current form, and we should
simply administer physical violence towards checkpatch wankers?

PS. I frequently practise 2).
PPS. I find your preferred label indenting truly hideous.

