Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab0GaJbZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 05:31:25 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54066 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab0GaJbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 05:31:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Shirley Ma <mashirle@us.ibm.com>
Subject: Re: [RFC PATCH v8 00/16] Provide a zero-copy method on KVM virtio-net.
Date: Sat, 31 Jul 2010 11:30:16 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4-next-20100709+; KDE/4.4.92; x86_64; ; )
Cc: "Xin, Xiaohui" <xiaohui.xin@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "herbert@gondor.apana.org.au" <herbert@gondor.hengli.com.au>,
        "jdike@linux.intel.com" <jdike@linux.intel.com>
References: <1280402088-5849-1-git-send-email-xiaohui.xin@intel.com> <F2E9EB7348B8264F86B6AB8151CE2D791BAB307158@shsmsx502.ccr.corp.intel.com> <1280505112.9058.31.camel@localhost.localdomain>
In-Reply-To: <1280505112.9058.31.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007311130.17000.arnd@arndb.de>
X-Provags-ID: V02:K0:RdVQu2oRbrpg01kIX7vrdjDUOHRwCMyJRAmxM7m8pPQ
 VrKtciT/l9rCw8ukoedRpNEhl6jss4jF2p0bVLrf0tp2qkbUo6
 OcvdN0pZyN9yJmbvU0TFTO3MLmeU5RZ7L0He5v7ZQ1NP08bz+0
 TwcCXmI8TZCPtBLcM/rlaaFJwFCLBbrMUyqJPfsz1xL2PNLopk
 NrJOQCojbvPoTH4TebZuw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 July 2010 17:51:52 Shirley Ma wrote:
> On Fri, 2010-07-30 at 16:53 +0800, Xin, Xiaohui wrote:
> > >Since vhost-net already supports macvtap/tun backends, do you think
> > >whether it's better to implement zero copy in macvtap/tun than
> > inducing
> > >a new media passthrough device here?
> > >
> > 
> > I'm not sure if there will be more duplicated code in the kernel. 
> 
> I think it should be less duplicated code in the kernel if we use
> macvtap to support what media passthrough driver here. Since macvtap has
> support virtio_net head and offloading already, the only missing func is
> zero copy. Also QEMU supports macvtap, we just need add a zero copy flag
> in option.

Yes, I fully agree and that was one of the intended directions for
macvtap to start with. Thank you so much for following up on that,
I've long been planning to work on macvtap zero-copy myself but it's
now lower on my priorities, so it's good to hear that you made progress
on it, even if there are still performance issues.

	Arnd
