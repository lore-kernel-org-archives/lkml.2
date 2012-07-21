Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618Ab2GUJld (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 05:41:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab2GUJlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 05:41:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20120720215738.14854.55273.stgit@warthog.procyon.org.uk>
References: <20120720215738.14854.55273.stgit@warthog.procyon.org.uk> <20120720215636.14854.41208.stgit@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de, tglx@linutronix.de,
        mingo@kernel.org, davej@redhat.com
Subject: Re: [PATCH 05/13] UAPI: Partition the header include path sets and add uapi/ header directories
Date: Sat, 21 Jul 2012 10:41:11 +0100
Message-ID: <1256.1342863671@warthog.procyon.org.uk>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> +		-Iinclude/uapi \

This needs prefacing with $(srctree)/.  I got it right in the commit message
but not in the patch.  Thanks to Fengguang Wu for finding it with his kernel
cruncher.

David
