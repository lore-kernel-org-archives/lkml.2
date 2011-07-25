Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726Ab1GYMiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 08:38:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45403 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462Ab1GYMhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 08:37:35 -0400
Date: Mon, 25 Jul 2011 14:36:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Anton Blanchard <anton@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, emunson@mgebm.net,
        linux-kernel@vger.kernel.org, amodra@gmail.com
Subject: Re: [PATCH] perf: Fix symbol resolution on old ppc64 ABI
Message-ID: <20110725123636.GA28530@elte.hu>
References: <20110725142356.0c722c6b@kryten>
 <20110725062542.GA694@elte.hu>
 <20110725204859.51e50611@kryten>
 <20110725105004.GN28787@elte.hu>
 <20110725223232.4e2dce43@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110725223232.4e2dce43@kryten>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Anton Blanchard <anton@samba.org> wrote:

> Hi Ingo,
> 
> > > It would cover most cases. There would be an issue with 
> > > functions that are less than 24 bytes in length (ie 6 
> > > instructions). Tiny functions are probably rare enough that we 
> > > can live with it.
> > 
> > Do such tiny functions get packed tightly, below 24 bytes? 
> > Another sanitization pass could solve that issue, to trim 
> > partially overlapping symbol regions, right?
> 
> That would work I think. Should I cook up a patch?

Yeah, would be nice - if Arnaldo agrees with the approach too.

Thanks,

	Ingo
