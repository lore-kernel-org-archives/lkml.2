Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab0CWJO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 05:14:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35901 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872Ab0CWJO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 05:14:56 -0400
Date: Tue, 23 Mar 2010 10:14:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [RFC PATCH -v2 4/4] x86: use lmb to replace early_res
Message-ID: <20100323091436.GA4576@elte.hu>
References: <1269333587-1866-1-git-send-email-yinghai@kernel.org>
 <1269333587-1866-5-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269333587-1866-5-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> still keep kernel/early_res.c for the extension.
> 
> should move those file to lib/lmb.c later?
> 
> -v2: fix NO_BOOTMEM hang with printk

Would be nice to track known TODO items - that way people dont feel that you 
are ignoring (or have missed) their feedback. For example are the list of 4 
improvements i suggested in the previous mail planned, or do you disagree with 
some of that?

Thanks,

	Ingo
