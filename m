Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab2DGA7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 20:59:33 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:53164 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752154Ab2DGA7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 20:59:32 -0400
Message-ID: <1333760371.8565.19.camel@joe2Laptop>
Subject: Re: [PATCH] printk: support structured and multi-facility log
 messages
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartmann <greg@kroah.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Date: Fri, 06 Apr 2012 17:59:31 -0700
In-Reply-To: <alpine.LRH.2.00.1204070222130.18937@twin.jikos.cz>
References: <1333569554.864.3.camel@mop>
	 <alpine.LRH.2.00.1204070222130.18937@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-04-07 at 02:26 +0200, Jiri Kosina wrote:
> On Wed, 4 Apr 2012, Kay Sievers wrote:
> 
> > - Output of dev_printk() is reliably machine-readable now. In addition
> >   to the printed plain text message, it creates a log dictionary with the
> >   following properties:
> >     SUBSYSTEM=     - the driver-core subsytem name
> >     DEVICE=
> >       b12:8        - block dev_t
> >       c127:3       - char dev_t
> >       n8           - netdev ifindex
> >       +sound:card0 - subsystem:devname
> 
> One of the questions that hasn't been raised yet, and which I personally 
> consider crucial -- are we making printk() interface part of userspace ABI 
> now by this?

I hope not.

> Today, we are free to change any printk()s and not feel guilty about it at 
> all. With this, we are making the whole thing much more systematic and 
> friendly for automatic userspace consumption.

It _may_ be that new KEYWORD=VALUE combinations may become
systematic and an ABI, but the content of the message is
still arbitrary and should be designated as changeable
without notice.



