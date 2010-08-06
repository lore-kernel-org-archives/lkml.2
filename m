Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761410Ab0HFPXJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 11:23:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757449Ab0HFPXG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 11:23:06 -0400
MIME-Version: 1.0
In-Reply-To: <20100806080642.GA4642@dspnet.fr>
References: <23662.1281056463@redhat.com> <20100806011706.GA21657@gondor.apana.org.au> 
	<20100806014057.GA22395@gondor.apana.org.au> <AANLkTi=+-Y2GOZYAZHeaX+op3XB9AY5S85rfJD3jSDvz@mail.gmail.com> 
	<20100806023539.GA22774@gondor.apana.org.au> <AANLkTimVOkAi1_G9B290fHRR3PbV4H9003VarAv_zbGn@mail.gmail.com> 
	<AANLkTinVO0prEfkuOUFWA12q8HwrXS6do_hjw1EqygZu@mail.gmail.com> 
	<20100806080642.GA4642@dspnet.fr>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Aug 2010 08:22:28 -0700
Message-ID: <AANLkTi=TG8xWAtqr+3GxJZxQZ+hkjeViJJJCru-BdyxX@mail.gmail.com>
Subject: Re: Initcall ordering problem (TTY vs modprobe vs MD5) and cryptomgr 
	problem
To: Olivier Galibert <galibert@pobox.com>
Cc: Kyle Moffett <kyle@moffetthome.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        David Howells <dhowells@redhat.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 6, 2010 at 1:06 AM, Olivier Galibert <galibert@pobox.com> wrote:
>
> Maybe Linus would be happier if the self-tests were limited (by
> default) to the hardware accelerators?  Having a software backup and
> the risk of data loss indeed makes things different.

No. I'd be happier if it was an OPTION.

And it damn well defaults to "off". Like all other options.

Then, for people who use it, and worry (and distro test kernels etc),
turn it on. But don't make it a forced feature, and don't make it
something that people think they _should_ turn on.

I have crypto enabled, but I don't _use_ it. The upside for me is
zero. Nil. Nada. And I bet that's the common case.

And dammit, it you don't trust the hardware, don't send the driver
upstreams. And if you worry about alpha-particles, you should run a
RAM test on every boot. But don't ask _me_ to run one.

It's that simple.

                    Linus
