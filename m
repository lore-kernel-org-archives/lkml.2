Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab1EDHDp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 03:03:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37794 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574Ab1EDHDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 03:03:41 -0400
Date: Wed, 4 May 2011 09:03:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sven Eckelmann <sven@narfation.org>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, x86@kernel.org,
        linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-cris-kernel@axis.com,
        linux-ia64@vger.kernel.org, linux-m32r@ml.linux-m32r.org,
        linux-m68k@vger.kernel.org, linux-mips@linux-mips.org,
        linux-am33-list@redhat.com, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH] atomic: add *_dec_not_zero
Message-ID: <20110504070312.GD20828@elte.hu>
References: <1304458235-28473-1-git-send-email-sven@narfation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304458235-28473-1-git-send-email-sven@narfation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sven Eckelmann <sven@narfation.org> wrote:

> Introduce an *_dec_not_zero operation.  Make this a special case of
> *_add_unless because batman-adv uses atomic_dec_not_zero in different
> places like re-broadcast queue or aggregation queue management. There
> are other non-final patches which may also want to use this macro.

>  arch/x86/include/asm/atomic.h      |    1 +
>  arch/x86/include/asm/atomic64_64.h |    1 +

Acked-by: Ingo Molnar <mingo@elte.hu>

Thanks,

	Ingo
