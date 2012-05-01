Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab2EAIft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 04:35:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58407 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424Ab2EAIfo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 04:35:44 -0400
References: <20120501135549.5c865717b33650002f083d4a@canb.auug.org.au> <1335848120.3621.13.camel@pasglop>
In-Reply-To: <1335848120.3621.13.camel@pasglop>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <580A368D-C0EA-4DC3-9F89-131AF961309E@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Mailer: iPhone Mail (9A406)
From: Alexander Graf <agraf@suse.de>
Subject: Re: linux-next: build failure after merge of the kvm-ppc tree
Date: Tue, 1 May 2012 10:37:22 +0200
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01.05.2012, at 06:55, Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Tue, 2012-05-01 at 13:55 +1000, Stephen Rothwell wrote:
>> After merging the kvm-ppc tree, today's linux-next build
>> (powerpc_ppc64_defconfig) failed like this:
>> 
>> arch/powerpc/kvm/built-in.o: In function `.kvm_spapr_tce_release':
>> book3s_64_vio.c:(.text+0x374c): undefined reference to `.kvm_put_kvm'
>> arch/powerpc/kvm/built-in.o: In function
>> `.kvm_vm_ioctl_create_spapr_tce':
>> (.text+0x3ae8): undefined reference to `.kvm_get_kvm'
>> 
>> Presumably caused by commit 969f70395d6d ("kvm/book3s: Make kernel
>> emulated H_PUT_TCE available for "PR" KVM").
>> 
>> I have used the kvm-ppc tree from next-20120430 for today. 
> 
> Hrm, I wrote that patch :-) It used to work... Alex, probably just a
> missing #include no ?

Well, in fact it even compiled just fine for me with my config.

Ben, I'm out today (labor day). Could you please try make defconfog and check why it fails?

Alex

