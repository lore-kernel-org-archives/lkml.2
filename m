Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972Ab2IYPfj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 11:35:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754598Ab2IYPfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 11:35:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20120925163037.20ba3f3c@pyramind.ukuu.org.uk>
References: <20120925163037.20ba3f3c@pyramind.ukuu.org.uk> <5555.1348531649@warthog.procyon.org.uk> <21845.1348585794@warthog.procyon.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: dhowells@redhat.com, rusty@rustcorp.com.au, herbert@gondor.hengli.com.au,
        pjones@redhat.com, jwboyer@redhat.com, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@linux-nfs.org
Subject: Re: Wrong system clock vs X.509 date specifiers
Date: Tue, 25 Sep 2012 16:35:20 +0100
Message-ID: <30071.1348587320@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> Generate a certificate that is valid from a few minutes before the
> wallclock time. It's a certificate policy question not a kernel hackery
> one.

That doesn't seem to be possible with openssl req.  What would you recommend?

David
