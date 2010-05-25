Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab0EYJn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 05:43:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245Ab0EYJnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 05:43:25 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <AANLkTilBIZ71S2cO1NNe_30yzXdWtfkQoFcl44ktFiVb@mail.gmail.com>
References: <AANLkTilBIZ71S2cO1NNe_30yzXdWtfkQoFcl44ktFiVb@mail.gmail.com> <1274135154-24082-1-git-send-email-walken@google.com> <1274135154-24082-11-git-send-email-walken@google.com> <31783.1274282492@redhat.com>
To: Michel Lespinasse <walken@google.com>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>,
       peterz@infradead.org
Subject: Re: [PATCH 10/10] Use down_read_critical() for /sys/<pid>/exe and /sys/<pid>/maps files
Date: Tue, 25 May 2010 10:42:53 +0100
Message-ID: <17704.1274780573@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Lespinasse <walken@google.com> wrote:

> - The cluster management software tracks ownership of sysv shm
> segments, potentially deleting them if they have been abandoned.
> /proc/<pid>/maps files are used as an input to these decisions.

ipcs manages to give you that information in its nattch column, I believe,
without touching /proc/pid/maps.

David
