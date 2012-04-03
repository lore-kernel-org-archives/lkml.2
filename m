Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab2DCWL4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 18:11:56 -0400
Received: from gate.crashing.org ([63.228.1.57]:58957 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754548Ab2DCWLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 18:11:55 -0400
Message-ID: <1333491102.3040.12.camel@pasglop>
Subject: Re: [REGRESSION][PATCH V4 3/3] bpf jit: Let the powerpc jit handle
 negative offsets
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
Cc: kaffeemonster@googlemail.com, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, matt@ozlabs.org
Date: Wed, 04 Apr 2012 08:11:42 +1000
In-Reply-To: <20120403.180302.342779808900865443.davem@davemloft.net>
References: <4F75CA89.4010709@googlemail.com>
	 <4F75D2A5.7060407@googlemail.com>
	 <20120403.180302.342779808900865443.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-03 at 18:03 -0400, David Miller wrote:

> > Signed-off-by: Jan Seiffert <kaffeemonster@googlemail.com>
> > 
> > I have only compile tested this, -ENOHARDWARE.
> > Can someone with more powerpc kung-fu review and maybe test this?
> > Esp. powerpc asm is not my strong point. I think i botched the
> > stack frame in the call setup. Help?
> 
> I'm not applying this until a powerpc person tests it.
> 
> Also, we have an ARM JIT in the tree which probably needs to
> be fixed similarly.

Matt's having a look at powerpc

Cheers,
Ben.


