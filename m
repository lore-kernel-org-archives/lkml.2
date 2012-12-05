Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab2LEKeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 05:34:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590Ab2LEKeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 05:34:13 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1354650748-11032-1-git-send-email-tim.gardner@canonical.com>
References: <1354650748-11032-1-git-send-email-tim.gardner@canonical.com>
To: Tim Gardner <tim.gardner@canonical.com>, Rusty Russell <rusty@ozlabs.org>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 3.7-rc8] lib/Makefile: Fix oid_registry build dependency
Date: Wed, 05 Dec 2012 10:34:04 +0000
Message-ID: <7018.1354703644@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Gardner <tim.gardner@canonical.com> wrote:

> It is $(obj)/oid_registry.o that is dependent on $(obj)/oid_registry_data.c.
> The object file cannot be built until $(obj)/oid_registry_data.c has been
> generated.
> 
> A periodic and hard to reproduce parallel build failure is due to
> this incorrect lib/Makefile dependency. The compile error is completely
> disingenuous.

Good catch.  This patch could go via Rusty's module signing tree.

Acked-by: David Howells <dhowells@redhat.com>
