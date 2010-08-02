Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab0HBJSP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 05:18:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104Ab0HBJSO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 05:18:14 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100801124059.GA7977@pengutronix.de>
References: <20100801124059.GA7977@pengutronix.de> <20100730142519.18287.22053.stgit@warthog.procyon.org.uk>
To: Uwe =?us-ascii?Q?=3D=3Fiso-8859-1=3FQ=3FKleine-K=3DF6nig=3F=3D?= 
	<u.kleine-koenig@pengutronix.de>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH] CIFS: Remove __exit mark from cifs_exit_dns_resolver()
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Date: Mon, 02 Aug 2010 10:17:56 +0100
Message-ID: <1253.1280740676@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:

> From time to time I think about introducing something like
> __init_or_exit that puts a function into .init.text if .exit.text is
> discarded.  Is it worth the effort?

It might be worth including __exit stuff in __init if we would otherwise have
discarded it.  Otherwise there's liable to be a bunch of stuff that we could
otherwise discard left hanging around permanently.  But your suggestion would
work too.

David
