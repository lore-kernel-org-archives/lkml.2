Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab0EUIDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 04:03:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977Ab0EUIDg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 04:03:36 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <AANLkTikMBdX5HMrqVs9U2IJLldQ7nQXJ8ivKg4POdFEn@mail.gmail.com>
References: <AANLkTikMBdX5HMrqVs9U2IJLldQ7nQXJ8ivKg4POdFEn@mail.gmail.com> <1274135154-24082-1-git-send-email-walken@google.com> <1274135154-24082-9-git-send-email-walken@google.com> <4405.1274276055@redhat.com>
To: Michel Lespinasse <walken@google.com>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH 08/10] rwsem: down_read_critical infrastructure support
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Date: Fri, 21 May 2010 09:03:04 +0100
Message-ID: <19291.1274428984@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Lespinasse <walken@google.com> wrote:

> > -       if (flags & RWSEM_UNFAIR)
> > +       if (type & RWSEM_WAITING_FOR_UNFAIR_READ)
> 
> if (type == RWSEM_WAITING_FOR_UNFAIR_READ)

Sorry, yes.
