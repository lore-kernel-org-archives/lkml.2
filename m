Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab2EAEzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 00:55:40 -0400
Received: from gate.crashing.org ([63.228.1.57]:46715 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288Ab2EAEzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 00:55:39 -0400
Message-ID: <1335848120.3621.13.camel@pasglop>
Subject: Re: linux-next: build failure after merge of the kvm-ppc tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Alexander Graf <agraf@suse.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 01 May 2012 14:55:20 +1000
In-Reply-To: <20120501135549.5c865717b33650002f083d4a@canb.auug.org.au>
References: <20120501135549.5c865717b33650002f083d4a@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-01 at 13:55 +1000, Stephen Rothwell wrote:
> After merging the kvm-ppc tree, today's linux-next build
> (powerpc_ppc64_defconfig) failed like this:
> 
> arch/powerpc/kvm/built-in.o: In function `.kvm_spapr_tce_release':
> book3s_64_vio.c:(.text+0x374c): undefined reference to `.kvm_put_kvm'
> arch/powerpc/kvm/built-in.o: In function
> `.kvm_vm_ioctl_create_spapr_tce':
> (.text+0x3ae8): undefined reference to `.kvm_get_kvm'
> 
> Presumably caused by commit 969f70395d6d ("kvm/book3s: Make kernel
> emulated H_PUT_TCE available for "PR" KVM").
> 
> I have used the kvm-ppc tree from next-20120430 for today. 

Hrm, I wrote that patch :-) It used to work... Alex, probably just a
missing #include no ?

Cheers,
Ben.


