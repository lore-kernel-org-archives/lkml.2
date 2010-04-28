Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab0D1SmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 14:42:24 -0400
Received: from mail.gmx.net ([213.165.64.20]:36076 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756358Ab0D1SmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 14:42:21 -0400
X-Authenticated: #15668376
X-Provags-ID: V01U2FsdGVkX18dHtE5vFkdBiAZzL9+aM8PksKX0+tXgHhgmDs1s0
	NWtXhL9RLjMZyG
From: Peter Fritzsche <Peter.Fritzsche@gmx.de>
To: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 2/2] asm-generic: Don't warn that atomic_t is only 24 bit
Date: Wed, 28 Apr 2010 20:42:09 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.33-2-686; KDE/4.4.2; i686; ; )
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Keith M Wesolowski <wesolows@foobazco.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
References: <1272451837-17961-1-git-send-email-peter.fritzsche@gmx.de> <20100428135434.GA4662@Krystal> <20100428152815.GB25569@shareable.org>
In-Reply-To: <20100428152815.GB25569@shareable.org>
MIME-Version: 1.0
Message-Id: <201004282042.15485.Peter.Fritzsche@gmx.de>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 April 2010 17:28:15 you wrote:

> If the comment's getting removed, it should probably go from here too:
> 
> linux-2.6$ git grep '24' arch/*/include/*/atomic*
> arch/mn10300/include/asm/atomic.h: * useful range of an atomic_t is only 24
> bits arch/mn10300/include/asm/atomic.h: * useful range of an atomic_t is
> only 24 bits arch/mn10300/include/asm/atomic.h: * Note that the guaranteed
> useful range of an arch/mn10300/include/asm/atomic.h: * Note that the
> guaranteed useful range of an

This is part one of the patch - already sent to the mn10300 people. Currently 
only got Acked reponses for both patches

Best regards,
	Peter Fritzsche
