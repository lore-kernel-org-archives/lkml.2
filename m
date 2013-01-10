Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab3AJSQp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 13:16:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755603Ab3AJSQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 13:16:43 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
In-Reply-To: <8057.1357834335@warthog.procyon.org.uk>
References: <8057.1357834335@warthog.procyon.org.uk> <CAGXu5jJtuorV9GcetPA+v9K4p-jX4oacaDPrJ3j+RTM+eK5kFA@mail.gmail.com> <24937.1357218319@warthog.procyon.org.uk>
From: David Howells <dhowells@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: dhowells@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Pull "Load keys from signed PE binaries" branch into linux-next
Date: Thu, 10 Jan 2013 18:16:40 +0000
Message-ID: <1656.1357841800@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > More of my paranoia for array access here. :)
>
> I've added this at the top of pkc7_digest():
> 
> 	if (pkcs7->sig.pkey_hash_algo > PKEY_HASH__LAST ||
> 	    pkey_hash_algo_name[pkcs7->sig.pkey_hash_algo])

There should be a '!' here.

> 		return -ENOPKG;

David
