Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965525Ab2FAQp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 12:45:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50413 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759270Ab2FAQp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 12:45:57 -0400
Date: Fri, 1 Jun 2012 17:45:18 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Philipp Riemer <ruderphilipp@gmail.com>
Cc: Joe Perches <joe@perches.com>, Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Paul Mundt <lethal@linux-sh.org>,
        Michael B?sch <m@bues.ch>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Wang Chen <ellre923@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] new mailmap file for the linux kernel git repository
Message-ID: <20120601164518.GI30000@ZenIV.linux.org.uk>
References: <CAFU-uVs_Gwacxj74cyekY2gv+zAq+Spba7nfPLdTc_dR3y8CYw@mail.gmail.com>
 <20120516143830.GA483@kroah.com>
 <alpine.LNX.2.00.1205161640520.8796@pobox.suse.cz>
 <CAFU-uVt94sgzq7DgsgKL2OJ0e7DazvNpFunx7BNEz88LHJOg+g@mail.gmail.com>
 <20120516150813.GA3293@kroah.com>
 <CAFU-uVvzyN0asmReOVJcAEiAtbQ=styfGxRRbnrJKgNFDS5X_g@mail.gmail.com>
 <CAFU-uVsStG0KoiQm95-uC8ZPXWAq=8Q8vXircxOuUCHhk+r9uw@mail.gmail.com>
 <1338492342.5861.23.camel@joe2Laptop>
 <20120531201502.GA30000@ZenIV.linux.org.uk>
 <CAFU-uVupiK5O-LC=wA3Tte78hjzwSJSwUGLb2-58VJSs5z0_hQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFU-uVupiK5O-LC=wA3Tte78hjzwSJSwUGLb2-58VJSs5z0_hQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2012 at 10:41:06AM +0200, Philipp Riemer wrote:
> Does your comment in parentheses mean that your "ftp.linux.org.uk" and
> "www.linux.org.uk" addresses
> (c|sh)ould be mapped onto "zeniv.linux.org.uk"?

ftp.linux.org.uk and zeniv.linux.org.uk are the same box; both variants
will work, but I prefer to use the latter in signoffs, etc.
www.linux.org.uk is an unrelated system and I have no idea if it'll
forward the mail sent to viro@... over to zeniv.  No reason for it
to do so...

> If no-one would care about correct name mappings, why does the
> .mailmap file in Git exist at all?

No idea.

> Or websites like Linux Kernel Patch
> Statistic
> <http://www.remword.com/kps_result/>?

Because people are prone to masturbation?  "Nation by line", my arse...
What next?  Number and ages of children[1]?  What a sad bunch of wankers...

[1] which probably _is_ a significant factor, unlike citizenship/nationality/
whatever the hell they meant there.
