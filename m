Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab1KKJWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 04:22:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47900 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783Ab1KKJWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 04:22:53 -0500
Date: Fri, 11 Nov 2011 10:21:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, David Rientjes <rientjes@google.com>,
        Arun Sharma <asharma@fb.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 1/7] x86, mm: Use MAX_DMA_PFN for ZONE_DMA on 32-bit
Message-ID: <20111111092101.GE14347@elte.hu>
References: <1320155902-10424-1-git-send-email-penberg@kernel.org>
 <CAOJsxLHHpb93onT9OPW4Q5HXjSHPukz8CxFKEiyP5jCSYYPxkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLHHpb93onT9OPW4Q5HXjSHPukz8CxFKEiyP5jCSYYPxkQ@mail.gmail.com>
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


* Pekka Enberg <penberg@kernel.org> wrote:

> On Tue, Nov 1, 2011 at 3:58 PM, Pekka Enberg <penberg@kernel.org> wrote:
> > Use MAX_DMA_PFN which represents the 16 MB ISA DMA limit on 32-bit x86 just
> > like we do on 64-bit.
> >
> > Acked-by: Tejun Heo <tj@kernel.org>
> > Acked-by: Yinghai Lu <yinghai@kernel.org>
> > Cc: H. Peter Anvin <hpa@linux.intel.com>
> > Acked-by: David Rientjes <rientjes@google.com>
> > Signed-off-by: Pekka Enberg <penberg@kernel.org>
> 
> 3.2-rc1 is out! Who do I have to bribe/sleep with to get this patch
> series merged to -tip?

For uncontroversial patches you can generally tempt me with the 
"Ingo, please this pull from ..." kind of bribe that saves me from 
having to process the patches ;-)

Anyway, applied them to tip:x86/mm from email.

Thanks,

	Ingo
