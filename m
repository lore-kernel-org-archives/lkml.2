Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759828Ab0GQKNZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 06:13:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55898 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754721Ab0GQKNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 06:13:24 -0400
Date: Sat, 17 Jul 2010 12:13:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, UV: initialize BAU MMRs only on hubs with cpus
Message-ID: <20100717101317.GH12435@elte.hu>
References: <E1OZmZN-0006cW-RC@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1OZmZN-0006cW-RC@eag09.americas.sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cliff Wickman <cpw@sgi.com> wrote:

> Remove the initialization of MMRs UVH_LB_BAU_SB_ACTIVATION_CONTROL and
> UVH_BAU_DATA_BROADCAST on UV hubs that have no active cpus.
> Such initialization on hubs with no active cpus would result in a kernel
> page fault.

Applied to tip:x86/uv, thanks.

	Ingo
