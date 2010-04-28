Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab0D1Nym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 09:54:42 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:35922 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751521Ab0D1Nyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 09:54:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEANfa10tGGNqG/2dsb2JhbACcbnK9OYUOBA
Date: Wed, 28 Apr 2010 09:54:34 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Peter Fritzsche <peter.fritzsche@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Keith M Wesolowski <wesolows@foobazco.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 2/2] asm-generic: Don't warn that atomic_t is only 24
	bit
Message-ID: <20100428135434.GA4662@Krystal>
References: <1272451837-17961-1-git-send-email-peter.fritzsche@gmx.de> <1272453036-18670-1-git-send-email-peter.fritzsche@gmx.de> <201004281533.29327.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <201004281533.29327.arnd@arndb.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 09:40:52 up 20 days, 23:34,  3 users,  load average: 0.29, 0.33,
	0.24
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann (arnd@arndb.de) wrote:
> On Wednesday 28 April 2010, Peter Fritzsche wrote:
> > 32-bit Sparc used to only allow usage of 24-bit of it's atomic_t type.
> > This was corrected with linux 2.6.3 when Keith M Wesolowski changed the
> > implementation to use the parisc approach of having an array of
> > spinlocks to protect the atomic_t.
> > 
> > These warnings were also removed from the sparc implementation when the
> > new implementation was merged in BKrev:402e4949VThdc6D3iaosSFUgabMfvw,
> > but the warning still remained in some other places without any
> > 24-bit-only atomic_t implementation inside the kernel.
> > 
> > We should remove these warnings to allow users to rely on the full
> > 32-bit range of atomic_t.
> > 
> > Signed-off-by: Peter Fritzsche <peter.fritzsche@gmx.de>
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>

AFAIK that was the last architecture imposing limitations below 32 bits
on atomic_t.

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
