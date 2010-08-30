Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab0H3KDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 06:03:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:58099 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754094Ab0H3KDU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 06:03:20 -0400
Subject: Re: linux-next: build failure after merge of the kvm tree
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <20100830113523.28e6fa9e.sfr@canb.auug.org.au>
Date: Mon, 30 Aug 2010 12:03:17 +0200
Cc: Avi Kivity <avi@qumranet.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <0568D973-31CA-4E44-8583-D39A58FCEDD8@suse.de>
References: <20100830113523.28e6fa9e.sfr@canb.auug.org.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 30.08.2010, at 03:35, Stephen Rothwell wrote:

> Hi all,
> 
> After merging the kvm tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> arch/powerpc/kernel/asm-offsets.c: In function 'main':
> arch/powerpc/kernel/asm-offsets.c:470: error: invalid use of undefined type 'struct kvm_vcpu_arch_shared'
> arch/powerpc/kernel/asm-offsets.c:472: error: invalid use of undefined type 'struct kvm_vcpu_arch_shared'
> arch/powerpc/kernel/asm-offsets.c:474: error: invalid use of undefined type 'struct kvm_vcpu_arch_shared'
> arch/powerpc/kernel/asm-offsets.c:476: error: invalid use of undefined type 'struct kvm_vcpu_arch_shared'
> arch/powerpc/kernel/asm-offsets.c:478: error: invalid use of undefined type 'struct kvm_vcpu_arch_shared'
> arch/powerpc/kernel/asm-offsets.c:479: error: invalid use of undefined type 'struct kvm_vcpu_arch_shared'
> 
> Caused by commits 3623fdb1aa54678f73da95e797eb6e4756d4bd0e ("KVM: PPC:
> Convert MSR to shared page") and 158a244474a6620715c626d4647fec4d61aaeee7
> ("KVM: PPC: Generic KVM PV guest support").
> 
> I have used the kvm tree from next-20100827 for today.

I sent a fix out to the ML. Avi or Marcelo, could you please merge that one in quickly? The !CONFIG_KVM but CONFIG_KVM_GUEST case was the one combination I didn't try out :(.

Alex

