Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab1BNOaT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 09:30:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33703 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655Ab1BNOaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 09:30:17 -0500
Date: Mon, 14 Feb 2011 15:30:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andreas.herrmann3@amd.com, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/amd-nb] x86, amd: Normalize compute unit IDs on
 multi-node processors
Message-ID: <20110214143006.GA28202@elte.hu>
References: <1295881543-572552-2-git-send-email-hans.rosenfeld@amd.com>
 <tip-d518573de63fb119e5e9a3137386544671387681@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-d518573de63fb119e5e9a3137386544671387681@git.kernel.org>
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


* tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> Commit-ID:  d518573de63fb119e5e9a3137386544671387681
> Gitweb:     http://git.kernel.org/tip/d518573de63fb119e5e9a3137386544671387681
> Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
> AuthorDate: Mon, 24 Jan 2011 16:05:40 +0100

Andreas,

the build is now producing this warning:

 arch/x86/kernel/cpu/amd.c: In function 'amd_detect_cmp':
 arch/x86/kernel/cpu/amd.c:268: warning: 'cores_per_cu' may be used uninitialized in this function
 arch/x86/kernel/cpu/amd.c:268: note: 'cores_per_cu' was declared here

Thanks,

	Ingo
