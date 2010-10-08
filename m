Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820Ab0JHIQU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 04:16:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39400 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755640Ab0JHIQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 04:16:18 -0400
Date: Fri, 8 Oct 2010 10:16:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Section mismatches in memblock
Message-ID: <20101008081604.GB13754@elte.hu>
References: <4CABAAB4.3090707@zytor.com>
 <4CABB4FD.2090304@kernel.org>
 <4CABDF3A.2020501@zytor.com>
 <4CABE739.8050001@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CABE739.8050001@kernel.org>
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


* H. Peter Anvin <hpa@kernel.org> wrote:

> On 10/05/2010 07:30 PM, H. Peter Anvin wrote:
> > 
> > Wrong functions!  Furhtermore, at least the tip tree definitely does not
> > have __init_memblock here:
> > 
> 
> Nevermind.  I had missed that Ingo had put stuff into core/memblock on
> top of x86/memblock, just to be confusing.

Correct - we better keep it as a generic, non-x86 topic as it affects 
other architectures. We can zap x86/memblock (it's fully contained in 
core/memblock) so that it's not confusing.

Thanks,

	Ingo
