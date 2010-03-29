Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab0C2UAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 16:00:45 -0400
Received: from mail.perches.com ([173.55.12.10]:1232 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562Ab0C2UAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 16:00:44 -0400
Subject: Re: [PATCH] treewide: Add and use ADD_MOD macro
From: Joe Perches <joe@perches.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jiri Kosina <trivial@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100329124708.898b617c.randy.dunlap@oracle.com>
References: <1269813447.1500.69.camel@Joe-Laptop.home>
	 <20100329124708.898b617c.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 13:00:42 -0700
Message-ID: <1269892842.4558.7.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-29 at 12:47 -0700, Randy Dunlap wrote:
> On Sun, 28 Mar 2010 14:57:27 -0700 Joe Perches wrote:
> > Add a macro for the somewhat common use of
> > 	(something + value) % value
> > because the test uses ADD_MOD
> > --- a/include/linux/kernel.h
> > +++ b/include/linux/kernel.h
> > +#define ADD_MOD(x, y) (((x) + (y)) % (y))
> It would be better not to evaluate y more than one time.

That could be said for nearly all the convenience
macros in kernel.h

> Also it's not safe for 64-bit 'y' on i386, right?
> Looks like it would cause missing reference to __imoddi3
> or whatever it is called.

Which is also true for nearly all the convenience
macros in kernel.h

> so it can easily be misused IMO.

etc.

