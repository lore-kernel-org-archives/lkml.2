Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887Ab0KKIzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 03:55:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52291 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757842Ab0KKIzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 03:55:32 -0500
Date: Thu, 11 Nov 2010 09:55:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, kees.cook@canonical.com,
        security@kernel.org
Subject: Re: [PATCH v3] Restrict unprivileged access to kernel syslog
Message-ID: <20101111085514.GA18789@elte.hu>
References: <1289431735.3847.9.camel@dan>
 <20101110154956.83a3f84d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101110154956.83a3f84d.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > CC: stable <stable@kernel.org>
> 
> hm.  Reasons for this?

I dont think so. Can we still try it for .37 though?

Thanks,

	Ingo
