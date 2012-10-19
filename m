Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946002Ab2JSWyV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 18:54:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945931Ab2JSWyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 18:54:20 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20121019225140.31460.32873.stgit@warthog.procyon.org.uk>
References: <20121019225140.31460.32873.stgit@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, rusty@rustcorp.com.au,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] MODSIGN: perlify sign-file and merge in x509keyid [ver #2]
Date: Fri, 19 Oct 2012 23:54:15 +0100
Message-ID: <1450.1350687255@warthog.procyon.org.uk>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> +	printk("Check for sig\n");
> +
> ...
> +			printk("Found sig\n");
> ...
> +#define DEBUG

And I also forgot to remove the debugging.  Sigh.

David
