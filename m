Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab2GEGCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 02:02:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44377 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673Ab2GEGCw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 02:02:52 -0400
Subject: Re: linux-next: build failure after merge of the kvm-ppc tree
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <20120705154929.219789032ef59f9243d0b8a5@canb.auug.org.au>
Date: Thu, 5 Jul 2012 08:02:45 +0200
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stuart Yoder <stuart.yoder@freescale.com>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <92A87EB2-E859-456C-85DE-7F0A4CC5F127@suse.de>
References: <20120705154929.219789032ef59f9243d0b8a5@canb.auug.org.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05.07.2012, at 07:49, Stephen Rothwell wrote:

> Hi Alexander,
> 
> After merging the kvm-ppc tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> arch/powerpc/kernel/exceptions-64s.S: Assembler messages:
> arch/powerpc/kernel/exceptions-64s.S:479: Error: wrong number of operands
> arch/powerpc/kernel/exceptions-64s.S:486: Error: wrong number of operands
> arch/powerpc/kernel/exceptions-64s.S:486: Error: wrong number of operands
> arch/powerpc/kernel/exceptions-64s.S:487: Error: wrong number of operands
> arch/powerpc/kernel/exceptions-64s.S:487: Error: wrong number of operands
> arch/powerpc/kernel/exceptions-64s.S:494: Error: wrong number of operands
> arch/powerpc/kernel/exceptions-64s.S:494: Error: wrong number of operands
> 
> Caused by commit bc8cc4993e19 ("PPC: use CURRENT_THREAD_INFO instead of
> open coded assembly").  The fact that this patch has problems was already
> pointed out on the linuxppc-dev mailing list and it clearly hasn't been
> build tested.
> 
> I have used the version of the kvm-ppc tree from next-20120703 for today.

Ah, yes, thanks. I kept the old, broken version in my tree to make sure I have the dependencies for (and don't forget) the (hopefully good) patches that follow on top, but was planning to replace it once we have a new version of the CURRENT_THREAD_INFO one.

Stuart, could you please send a new version of the CURRENT_THREAD_INFO patch?


Alex

