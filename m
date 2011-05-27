Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519Ab1E0JlD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 05:41:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39092 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757391Ab1E0JlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 05:41:01 -0400
Date: Fri, 27 May 2011 11:40:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Jones <davej@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Tony Luck <tony.luck@gmail.com>, linux-kernel@vger.kernel.org,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        torvalds@linux-foundation.org, adobriyan@gmail.com, penberg@kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
Message-ID: <20110527094047.GJ21386@elte.hu>
References: <1306269105.21443.20.camel@dan>
 <201105270018.36835.rjw@sisk.pl>
 <4DDED4ED.7020806@zytor.com>
 <20110527024556.GA22396@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110527024556.GA22396@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Dave Jones <davej@redhat.com> wrote:

> On Thu, May 26, 2011 at 03:32:13PM -0700, H. Peter Anvin wrote:
>  > On 05/26/2011 03:18 PM, Rafael J. Wysocki wrote:
>  > > 
>  > > Well, as far as I can tell, this feature is going to break hibernation on
>  > > both x86_32 and x86_64 at the moment, unless you can guarantee that the
>  > > randomized kernel location will be the same for both the boot and the target
>  > > kernels.
>  > > 
>  > 
>  > Obviously we can't and we don't.  I'm a bit surprised at that
>  > constraint... how can that constraint not break things like kernels of
>  > slightly different size?
> 
> In Fedora at least, we make sure the kernel you thaw from is the 
> same one you booted by diddling with grub to force the right kernel 
> to be booted.

Btw., the hibernation code should save a signature and make sure that 
the two kernels match! It's really broken if the code allows blind 
thawing ...

Thanks,

	Ingo
