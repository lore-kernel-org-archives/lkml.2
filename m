Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757775Ab0ESMdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 08:33:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146Ab0ESMdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 08:33:49 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1274135154-24082-5-git-send-email-walken@google.com>
References: <1274135154-24082-5-git-send-email-walken@google.com> <1274135154-24082-1-git-send-email-walken@google.com>
To: Michel Lespinasse <walken@google.com>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH 04/10] rwsem: let RWSEM_WAITING_BIAS represent any number of waiting threads
Date: Wed, 19 May 2010 13:33:24 +0100
Message-ID: <8146.1274272404@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Lespinasse <walken@google.com> wrote:

> Previously each waiting thread added a bias of RWSEM_WAITING_BIAS. With this
> change, the bias is added only once when the wait list is non-empty.

You might want to change "when the wait list" to "to indicate that the wait
list".  But apart from that:

Acked-by: David Howells <dhowells@redhat.com>
