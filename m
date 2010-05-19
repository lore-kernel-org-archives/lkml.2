Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab0ESMvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 08:51:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758079Ab0ESMvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 08:51:50 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1274135154-24082-7-git-send-email-walken@google.com>
References: <1274135154-24082-7-git-send-email-walken@google.com> <1274135154-24082-1-git-send-email-walken@google.com>
To: Michel Lespinasse <walken@google.com>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH 06/10] rwsem: smaller wrappers around rwsem_down_failed_common
Date: Wed, 19 May 2010 13:51:17 +0100
Message-ID: <13209.1274273477@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Michel Lespinasse <walken@google.com> wrote:

> More code can be pushed from rwsem_down_read_failed and
> rwsem_down_write_failed into rwsem_down_failed_common.
> 
> Following change adding down_read_unfair infrastructure support also
> enjoys having flags available in a register rather than having to
> fish it out in the struct rwsem_waiter...
> 
> Signed-off-by: Michel Lespinasse <walken@google.com>

Acked-by: David Howells <dhowells@redhat.com>
