Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab2DEIIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 04:08:25 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:19049 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab2DEIIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 04:08:22 -0400
Date: Thu, 5 Apr 2012 10:08:20 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Kay Sievers <kay@vrfy.org>
Cc: Joe Perches <joe@perches.com>, Greg Kroah-Hartmann <greg@kroah.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] printk: support structured and multi-facility log
	messages
Message-ID: <20120405080820.GB17658@merkur.ravnborg.org>
References: <1333569554.864.3.camel@mop> <1333583480.23520.37.camel@joe2Laptop> <20120405003321.GB27595@kroah.com> <1333586419.23520.52.camel@joe2Laptop> <CAPXgP11qdyccftPPA9LSRKVb-Xnf8BzP+deUmTzHnuVxoTQKog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPXgP11qdyccftPPA9LSRKVb-Xnf8BzP+deUmTzHnuVxoTQKog@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > How are arbitrary key/value pairs attached
> > in a printk?
> 
> There are 120 lines in the changelog, and a 100 lines large comment
> block in the source code, and another 50 lines spread over the code,
> and the hexdump examples in it, and all that? Even without looking at
> a single line of code, it should be explained from different
> viewpoints more than once.

color me blind - but I could not find any example of how I specify
key/value pairs when I use printk().

I could find lots of internal information - that parts looks to
be extensively documented - good.

But how I as a user specify this I failed to find.
Today I do:

    printk(KERN_ERR "foobar is bad");

But how is that extended to include the key/value pairs?


	Sam
