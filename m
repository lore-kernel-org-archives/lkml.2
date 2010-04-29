Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933258Ab0D3RY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:24:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933249Ab0D3RYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:24:12 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100428162708.GB2846@Krystal>
References: <20100428162708.GB2846@Krystal> <1272451837-17961-1-git-send-email-peter.fritzsche@gmx.de> <1272453036-18670-1-git-send-email-peter.fritzsche@gmx.de> <201004281533.29327.arnd@arndb.de> <20100428135434.GA4662@Krystal> <20100428152815.GB25569@shareable.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: dhowells@redhat.com, Jamie Lokier <jamie@shareable.org>,
       Arnd Bergmann <arnd@arndb.de>, Peter Fritzsche <peter.fritzsche@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Keith M Wesolowski <wesolows@foobazco.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 2/2] asm-generic: Don't warn that atomic_t is only 24 bit
Date: Thu, 29 Apr 2010 17:22:08 +0100
Message-ID: <22809.1272558128@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> How about simply replacing arch/mn10300/include/asm/atomic.h by:
> 
> arch/mn10300/include/asm/atomic.h:
> #include <asm-generic/atomic.h>
> 
> ?
> 
> This should have been done a while ago. They are almost the same, except for
> added cmpxchg*_local() in the asm-generic version (which would benefit to
> mn10300).

Fine by me.

David
