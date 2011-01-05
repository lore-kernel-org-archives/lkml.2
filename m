Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab1AERik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 12:38:40 -0500
Received: from inx.pm.waw.pl ([195.116.170.130]:41121 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073Ab1AERij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 12:38:39 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Joe Perches <joe@perches.com>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Dan Carpenter <error27@gmail.com>, Andy Whitcroft <apw@canonical.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] checkpatch: putting the && or || on the wrong line
References: <20110104055900.GA5062@bicker>
	<20110104163836.GA30317@fieldses.org>
	<20110104164414.GX5875@const.bordeaux.inria.fr>
	<1294160834.6617.51.camel@Joe-Laptop>
Date: Wed, 05 Jan 2011 18:38:07 +0100
In-Reply-To: <1294160834.6617.51.camel@Joe-Laptop> (Joe Perches's message of
	"Tue, 04 Jan 2011 09:07:14 -0800")
Message-ID: <m3fwt7i740.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> As do I, but perhaps coding style in a project like this
> shouldn't be personal but collective.

I think there is nothing like a collective style.
What you can eventually achieve is a style everybody hates.

> The trailing style outnumbers the leading style ~ 5:1.
>
> $ grep -rP --include=*.[ch] "(\|\||&&)[ \t]*$" * | wc -l
> 39890
> $ grep -rP --include=*.[ch] "^[ \t]*(\|\||&&)" * | wc -l
> 8244
>
> If you take out drivers/staging, trailing is used ~ 6:1.
>
> I think that high enough to be declared the preferred style.

This is a very weak reason (if any at all) to do so. Increasing e.g.
readability of the code would be a good reason, but statistics?

Maybe: Microsoft Windows outnumbers Linux X:1, so it should be declared
the "preferred" system (= the only allowed, as with CodingStyle and
checkpatch "errors").

Or: cars outnumber trucks X:1, declare the trucks illegal.
Coffee drinkers outnumber tee drinkers, kill the later.


Yes, we need some basic common style (tabs length, unless/until we can
use any tab length), K&R (or other) parentheses, void *var instead of
void* var (void* var1, var2 bugs), (no) spaces etc. Anything less make
the code unreadable or less readable. We should stop dictating the
details when the benefits end, and they end pretty fast.
-- 
Krzysztof Halasa
