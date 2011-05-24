Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932858Ab1EXTbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 15:31:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42897 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932806Ab1EXTbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 15:31:13 -0400
Date: Tue, 24 May 2011 21:30:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, penberg@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v6] x86: UV uv_tlb.c cleanup
Message-ID: <20110524193059.GA25098@elte.hu>
References: <E1QOw12-0004MN-Lp@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1QOw12-0004MN-Lp@eag09.americas.sgi.com>
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


* Cliff Wickman <cpw@sgi.com> wrote:

> General readability cleanup of tlb_uv.c. Now:
> - no function has over 50 non-comment lines
> - very few statements of over 80 characters need to be broken

So, have you checked whether this patch applies cleanly to the latest x86 tree?

Thanks,

	Ingo
