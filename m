Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab0G3PwF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 11:52:05 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:52696 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192Ab0G3PwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 11:52:01 -0400
Subject: RE: [RFC PATCH v8 00/16] Provide a zero-copy method on KVM
 virtio-net.
From: Shirley Ma <mashirle@us.ibm.com>
To: "Xin, Xiaohui" <xiaohui.xin@intel.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "herbert@gondor.apana.org.au" <herbert@gondor.hengli.com.au>,
        "jdike@linux.intel.com" <jdike@linux.intel.com>
In-Reply-To: <F2E9EB7348B8264F86B6AB8151CE2D791BAB307158@shsmsx502.ccr.corp.intel.com>
References: <1280402088-5849-1-git-send-email-xiaohui.xin@intel.com>
	 <1280442682.9058.15.camel@localhost.localdomain>
	 <F2E9EB7348B8264F86B6AB8151CE2D791BAB307158@shsmsx502.ccr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Jul 2010 08:51:52 -0700
Message-ID: <1280505112.9058.31.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Xiaohui,

On Fri, 2010-07-30 at 16:53 +0800, Xin, Xiaohui wrote:
> >Since vhost-net already supports macvtap/tun backends, do you think
> >whether it's better to implement zero copy in macvtap/tun than
> inducing
> >a new media passthrough device here?
> >
> 
> I'm not sure if there will be more duplicated code in the kernel. 

I think it should be less duplicated code in the kernel if we use
macvtap to support what media passthrough driver here. Since macvtap has
support virtio_net head and offloading already, the only missing func is
zero copy. Also QEMU supports macvtap, we just need add a zero copy flag
in option.

Thanks
Shirley

