Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab0ELNKG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 09:10:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058Ab0ELNKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 09:10:04 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1273634462-2672-12-git-send-email-walken@google.com>
References: <1273634462-2672-12-git-send-email-walken@google.com> <1273634462-2672-1-git-send-email-walken@google.com>
To: Michel Lespinasse <walken@google.com>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH 11/12] x86 rwsem: down_read_unfair implementation
Date: Wed, 12 May 2010 14:08:36 +0100
Message-ID: <10139.1273669716@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Lespinasse <walken@google.com> wrote:

>  #define RWSEM_WAITING_BIAS		(-RWSEM_ACTIVE_MASK-1)
>  #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
> +#define RWSEM_ACTIVE_WRITE_BIAS		(2 * RWSEM_WAITING_BIAS + \
> +					 RWSEM_ACTIVE_BIAS)

These are getting a bit meaningless.  Can you replace them with hex numbers to
make it clearer what's going on?  Putting a worked example in the patch
description would be good too.

David
