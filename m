Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab2K1NT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 08:19:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858Ab2K1NTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 08:19:24 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1353716808-16375-8-git-send-email-cesarb@cesarb.net>
References: <1353716808-16375-8-git-send-email-cesarb@cesarb.net> <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/24] MAINTAINERS: adjust for UAPI
Date: Wed, 28 Nov 2012 13:19:20 +0000
Message-ID: <26215.1354108760@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cesar Eduardo Barros <cesarb@cesarb.net> wrote:

> Several headers were moved or split to uapi/.

I was going to wait to do this till all the bits have got upstream.  Several
are still wending their way through maintainer trees.  Feel free to send your
patch to Linus with:

	Acked-by: David Howells <dhowells@redhat.com>

attached, though.

David
