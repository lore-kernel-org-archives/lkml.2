Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab2D3EaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 00:30:15 -0400
Received: from gate.crashing.org ([63.228.1.57]:33621 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012Ab2D3EaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 00:30:13 -0400
Message-ID: <1335760199.20866.33.camel@pasglop>
Subject: Re: [REGRESSION][PATCH V4 3/3] bpf jit: Let the powerpc jit handle
 negative offsets
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: kaffeemonster@googlemail.com
Cc: David Miller <davem@davemloft.net>, eric.dumazet@gmail.com,
        matt@ozlabs.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date: Mon, 30 Apr 2012 14:29:59 +1000
In-Reply-To: <4F9E1496.9060603@googlemail.com>
References: <4F75CA89.4010709@googlemail.com>
	 <4F75D2A5.7060407@googlemail.com>
	 <20120403.180302.342779808900865443.davem@davemloft.net>
	 <1333491102.3040.12.camel@pasglop> <1335753820.20866.27.camel@pasglop>
	 <1335759088.20866.32.camel@pasglop> <4F9E1496.9060603@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-30 at 06:27 +0200, Jan Seiffert wrote:
> Benjamin Herrenschmidt schrieb:
> > On Mon, 2012-04-30 at 12:43 +1000, Benjamin Herrenschmidt wrote:
> > 
> >>> Matt's having a look at powerpc
> >>
> >> Ok, he hasn't so I'll dig a bit.
> >>
> >> No obvious wrongness (but I'm not very familiar with bpf), though I do
> >> have a comment: sk_negative_common() and bpf_slow_path_common() should
> >> be made one and single macro which takes the fallback function as an
> >> argument.
> > 
> > Ok, with the compile fix below it seems to work for me:
> > 
> > (Feel free to fold that into the original patch)
> > 
> 
> Should i resend the complete patch with the compile fix?

Won't hurt...

BTW. Any idea about that bpf_program vs. sock_fprog issue I mentioned
earlier ?

Cheers,
Ben.


