Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128Ab2BISH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 13:07:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239Ab2BISH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 13:07:27 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CA+55aFw5z85wuU8xJ_YFp0QB653yAGPOqeGXhJLbdj9ogpHqOA@mail.gmail.com>
References: <CA+55aFw5z85wuU8xJ_YFp0QB653yAGPOqeGXhJLbdj9ogpHqOA@mail.gmail.com> <20120209154819.32070.93358.stgit@warthog.procyon.org.uk> <1328804920.6099.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <CA+55aFxHdFa4otDWJg4f+8sKEP3MBZqKBQCnH0Q8LXYtpdt1EA@mail.gmail.com> <CA+55aFyw1n=Bz3vi73RD5R13HyWLaVyPZc_z5rR7nGPzvs-BOw@mail.gmail.com> <7095.1328809567@redhat.com> 
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Eric Dumazet <eric.dumazet@gmail.com>,
        adobriyan@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Reduce the number of expensive division instructions done by _parse_integer()
Date: Thu, 09 Feb 2012 18:07:21 +0000
Message-ID: <8689.1328810841@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Bah. The constant is hoisted out of the loop on anything that has
> enough registers - and "cannot generate constants" is almost
> universally associated with "fair amount of registers".

True.

Do you want me to attach my patch description to your patch, or do you want to
do that?

David
