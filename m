Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab0FHTQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 15:16:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47384 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140Ab0FHTQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 15:16:29 -0400
Date: Tue, 8 Jun 2010 21:16:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, gregkh@suse.de,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/11] x86, UV: calculate BAU destination timeout
Message-ID: <20100608191617.GE25985@elte.hu>
References: <E1OJvNx-0004Zq-RK@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1OJvNx-0004Zq-RK@eag09.americas.sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4683]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cliff, this 11 patch UV series looks a lot more manageable (and very clean as 
well), so i've applied them to tip:x86/uv.

Thanks!

	Ingo
