Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab2GTOVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 10:21:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473Ab2GTOVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 10:21:49 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <201207201353.34324.arnd@arndb.de>
References: <201207201353.34324.arnd@arndb.de> <20120720125657.15422.12922.stgit@warthog.procyon.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Subject: Re: [PATCH] MPILIB: Provide count_leading/trailing_zeros() based on arch functions
Date: Fri, 20 Jul 2012 15:21:39 +0100
Message-ID: <5723.1342794099@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> wrote:

> I don't generally like to put stuff into asm-generic when it's unlikely
> to be overridden by architectures. It would really belong into
> include/linux, but then again we have all the other bitops in asm-generic
> as well, so whatever...

Some arches (such as Sparc, I think) have count-leading-zero instructions.

David
