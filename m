Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327Ab1EMKQI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 06:16:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58981 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756792Ab1EMKQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 06:16:05 -0400
Date: Fri, 13 May 2011 12:15:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 8/9] x86: Implement strict user copy checks for x86_64
Message-ID: <20110513101545.GF21022@elte.hu>
References: <1305244212-19183-1-git-send-email-sboyd@codeaurora.org>
 <1305244212-19183-9-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305244212-19183-9-git-send-email-sboyd@codeaurora.org>
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


* Stephen Boyd <sboyd@codeaurora.org> wrote:

> Strict user copy checks are only really supported on x86_32 even
> though the config option is selectable on x86_64. Add the
> necessary support to the 64 bit code to trigger copy_from_user()
> warnings at compile time.
> 
> Cc: x86@kernel.org
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  arch/x86/include/asm/uaccess_64.h |   12 +++++++++---
>  arch/x86/lib/usercopy_64.c        |    6 ++++++
>  2 files changed, 15 insertions(+), 3 deletions(-)

Very nice!

Acked-by: Ingo Molnar <mingo@elte.hu>

Thanks,

	Ingo
