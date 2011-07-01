Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064Ab1GAXPf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 19:15:35 -0400
Received: from gate.crashing.org ([63.228.1.57]:60909 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756745Ab1GAXPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 19:15:34 -0400
Subject: Re: [PATCH 2/2] powerpc/mm: Fix memory_block_size_bytes() for
 non-pseries
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
In-Reply-To: <20110701121516.GD28008@elte.hu>
References: <1308013071.2874.785.camel@pasglop>
	 <20110701121516.GD28008@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 02 Jul 2011 09:15:12 +1000
Message-ID: <1309562112.14501.257.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-01 at 14:15 +0200, Ingo Molnar wrote:

> > +/* WARNING: This is going to override the generic definition whenever
> > + * pseries is built-in regardless of what platform is active at boot
> > + * time. This is fine for now as this is the only "option" and it
> > + * should work everywhere. If not, we'll have to turn this into a
> > + * ppc_md. callback
> > + */
> 
> Just a small nit, please use the customary (multi-line) comment 
> style:
> 
>   /*
>    * Comment .....
>    * ...... goes here.
>    */
> 
> specified in Documentation/CodingStyle.

Ah ! Here goes my sneak attempts at violating coding style while nobody
notices :-)

No seriously, that sort of stuff shouldn't be such a hard rule... In
some cases the "official" way looks nicer, on some cases it's just a
waste of space, and I've grown to prefer my slightly more compact form,
at least depending on how the surrounding code looks like.

Since that's all powerpc arch code, I believe I'm entitled to that
little bit of flexibility in how the code looks like :-) It's not
like I'm GoingToPlayWithCaps() or switching to 3-char tabs :-)

Cheers,
Ben.


