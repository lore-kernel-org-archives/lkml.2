Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab2JVJnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 05:43:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8373 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451Ab2JVJnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 05:43:19 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <50835703.30608@xenotime.net>
References: <50835703.30608@xenotime.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: dhowells@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] module_signing: fix printk format warning
Date: Mon, 22 Oct 2012 10:43:16 +0100
Message-ID: <18249.1350898996@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <rdunlap@xenotime.net> wrote:

> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> kernel/module_signing.c:195:2: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'size_t'
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> Cc: David Howells <dhowells@redhat.com>

Hmmm...  My compiler doesn't show that, which is a bit surprising.

Acked-by: David Howells <dhowells@redhat.com>
