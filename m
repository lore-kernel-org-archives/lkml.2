Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab1EaMyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 08:54:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48319 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448Ab1EaMy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 08:54:29 -0400
Date: Tue, 31 May 2011 14:54:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH 0/5] x86-64: Remove syscall instructions at fixed
 addresses
Message-ID: <20110531125415.GD10249@elte.hu>
References: <cover.1306517576.git.luto@mit.edu>
 <20110529191924.GD9835@elte.hu>
 <BANLkTin9xfS_X9Bscf1qnNZMK=JBgpzV8Q@mail.gmail.com>
 <20110531080758.GA24172@elte.hu>
 <BANLkTi=Gi_0Uyj+dA6GjriRU9fCzKuLU=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=Gi_0Uyj+dA6GjriRU9fCzKuLU=g@mail.gmail.com>
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


* Andrew Lutomirski <luto@mit.edu> wrote:

> [...] More importantly, vread_tsc contains an alternative and the 
> vDSO can't currently contain alternative instructions.  That can 
> probably be fixed, but it'll take a bit of work.

You could start with picking the more compatible alternative 
instruction initially. I don't at all mind losing half a cycle of 
performance in that case ... this code should be secure first.

Thanks,

	Ingo
