Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758407Ab2DGA0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 20:26:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50659 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220Ab2DGA0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 20:26:34 -0400
Date: Sat, 7 Apr 2012 02:26:26 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Kay Sievers <kay@vrfy.org>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartmann <greg@kroah.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] printk: support structured and multi-facility log
 messages
In-Reply-To: <1333569554.864.3.camel@mop>
Message-ID: <alpine.LRH.2.00.1204070222130.18937@twin.jikos.cz>
References: <1333569554.864.3.camel@mop>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2012, Kay Sievers wrote:

> - Output of dev_printk() is reliably machine-readable now. In addition
>   to the printed plain text message, it creates a log dictionary with the
>   following properties:
>     SUBSYSTEM=     - the driver-core subsytem name
>     DEVICE=
>       b12:8        - block dev_t
>       c127:3       - char dev_t
>       n8           - netdev ifindex
>       +sound:card0 - subsystem:devname

One of the questions that hasn't been raised yet, and which I personally 
consider crucial -- are we making printk() interface part of userspace ABI 
now by this?

Today, we are free to change any printk()s and not feel guilty about it at 
all. With this, we are making the whole thing much more systematic and 
friendly for automatic userspace consumption. Nnot really different to, 
for example uevents, which I believe everyone considers userspace ABI now.

Do we really want that?

-- 
Jiri Kosina
SUSE Labs

