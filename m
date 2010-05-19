Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025Ab0ESMpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 08:45:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757886Ab0ESMph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 08:45:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1274135154-24082-6-git-send-email-walken@google.com>
References: <1274135154-24082-6-git-send-email-walken@google.com> <1274135154-24082-1-git-send-email-walken@google.com>
To: Michel Lespinasse <walken@google.com>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH 05/10] rwsem: wake queued readers when writer blocks on active read lock
Date: Wed, 19 May 2010 13:44:57 +0100
Message-ID: <10704.1274273097@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Lespinasse <walken@google.com> wrote:

> +	 * Alternatively, if we're called from a failed down_write(), there
> +	 * were already threads queued before us, and there are no active
> +	 * writers, the lock must be read owned; so we try to wake any read
> +	 * locks that were queued ahead of us. */

The comma you've added after 'us' is wrong.  That suggests that the implicit
'then' comes there.  I take it you're a proponent of the Oxford/Harvard/serial
comma?

Apart from that miscellaneous grammatical difference, the patch is fine:-)

David
