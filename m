Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283Ab0JJKlj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 06:41:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55930 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756708Ab0JJKli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 06:41:38 -0400
Date: Sun, 10 Oct 2010 12:41:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robin Holt <holt@sgi.com>
Cc: Russ Anderson <rja@sgi.com>, Yinghai Lu <yinghai@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
        "H. Peter Anvin" <h.peter.anvin@intel.com>,
        Jack Steiner <steiner@sgi.com>
Subject: Re: [BUG] x86: bootmem broken on SGI UV
Message-ID: <20101010104129.GB30271@elte.hu>
References: <20101008213429.GB7223@sgi.com>
 <4CAFA1DB.6010802@kernel.org>
 <20101009125944.GA18248@sgi.com>
 <20101009163908.GX14068@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101009163908.GX14068@sgi.com>
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


* Robin Holt <holt@sgi.com> wrote:

> On Sat, Oct 09, 2010 at 07:59:45AM -0500, Russ Anderson wrote:
> > Yes, Yinghai's patch fixes the problem.
> > Thank you very much.
> 
> Will this be included in 2.6.36?  It is needed for boot in order for UV
> systems to boot.

-tip uses memblock APIs. If this happens with vanilla -git as well then 
we need a bootmem backport for the fix.

	Ingo
