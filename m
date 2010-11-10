Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab0KJLP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 06:15:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56630 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753672Ab0KJLP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 06:15:56 -0500
Date: Wed, 10 Nov 2010 12:15:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kees Cook <kees.cook@canonical.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Security] [PATCH v3 0/4] x86: clear XD_DISABLED flag on Intel
 to regain NX
Message-ID: <20101110111547.GA11274@elte.hu>
References: <20101109181157.GE5876@outflux.net>
 <20101109183142.4ebfa737@lxorguk.ukuu.org.uk>
 <20101109185604.GK5876@outflux.net>
 <20101109225000.1b90e720@lxorguk.ukuu.org.uk>
 <20101109235314.GD5876@outflux.net>
 <20101110002153.7af92a1f@lxorguk.ukuu.org.uk>
 <20101110004347.GF5876@outflux.net>
 <20101110011039.GG5876@outflux.net>
 <20101110111144.72798d76@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101110111144.72798d76@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0054]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > So, based on that, there doesn't seem to be an errata related to _needing_
> > to disable the XD cpu feature.
> 
> Then you have my Ack at least for it.

Great! Kees, mind posting the latest version of the series with all the Acks 
included as well?

Thanks,

	Ingo
