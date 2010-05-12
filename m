Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab0ELMh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 08:37:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502Ab0ELMhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 08:37:25 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1273634462-2672-9-git-send-email-walken@google.com>
References: <1273634462-2672-9-git-send-email-walken@google.com> <1273634462-2672-1-git-send-email-walken@google.com>
To: Michel Lespinasse <walken@google.com>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH 08/12] rwsem: smaller wrappers around rwsem_down_failed_common
Date: Wed, 12 May 2010 13:36:32 +0100
Message-ID: <27269.1273667792@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Have you tried compiling this patch?

lib/rwsem.c: In function 'rwsem_down_failed_common':
lib/rwsem.c:177: error: invalid type argument of '->' (have 'struct rwsem_waiter')

There's a list_add_tail() that refers to waiter->list

David
