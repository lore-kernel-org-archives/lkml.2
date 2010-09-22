Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab0IVPda (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 11:33:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755117Ab0IVPd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 11:33:29 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1283888517.23280.241.camel@Joe-Laptop>
References: <1283888517.23280.241.camel@Joe-Laptop> <23323.1283864982@redhat.com> <20100907180025.GD2662@shadowen.org>
To: Joe Perches <joe@perches.com>
Cc: dhowells@redhat.com, Andy Whitcroft <apw@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: checkpatch problem
Date: Wed, 22 Sep 2010 16:33:12 +0100
Message-ID: <25759.1285169592@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> wrote:

> Maybe restrict the test to $logFunctions that have whitespace
> before newlines?
> 
> Something like below.
> 
> Caveat: it doesn't necessarily report on the proper line.
> 
> For instance:
> 	printk(KERN_DEBUG "ABCDEF \n");
> vs
> 	printk(KERN_DEBUG "ABC"
> 	       "DEF \n");
> 
> The second example reports the whitespace on the first line,
> not the second line.
> 
>  scripts/checkpatch.pl |   21 ++++++++++++++++-----
>  1 files changed, 16 insertions(+), 5 deletions(-)

Works for me.

David
