Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab0IARPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 13:15:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57710 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273Ab0IARPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 13:15:17 -0400
Date: Wed, 1 Sep 2010 19:15:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Don Zickus <dzickus@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, peterz@infradead.org,
        fweisbec@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] [lockup detector] sync touch_*_watchdog back to old
 semantics
Message-ID: <20100901171507.GA23357@elte.hu>
References: <wjkv24h3mpbpnoxk45o0ts96.1283355915765@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <wjkv24h3mpbpnoxk45o0ts96.1283355915765@email.android.com>
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


* Don Zickus <dzickus@redhat.com> wrote:

> Top posting because droid won't let me bottom post
> 
> This patch was the result of a regression with acpi and preempt.  Akpm 
> asked that I not change the semantics of the old touch_nmi_watchdog.  
> So I tried to revert to the old behaviour.

that's ok - i extended the changelog a bit before applying the patch.

Thanks,

	Ingo
