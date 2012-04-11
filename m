Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933544Ab2DKW0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 18:26:19 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:40099 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933500Ab2DKW0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 18:26:17 -0400
Date: Thu, 12 Apr 2012 07:26:12 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 00/13] KVM: MMU: fast page fault
Message-Id: <20120412072612.592b51427b04174ca7ecdf9f@gmail.com>
In-Reply-To: <4F85936A.6060509@redhat.com>
References: <4F742951.7080003@linux.vnet.ibm.com>
	<4F82E04E.6000900@redhat.com>
	<20120409175829.GB21894@amt.cnet>
	<4F8329D3.7000605@gmail.com>
	<20120409194614.GB23053@amt.cnet>
	<4F840DD2.3090101@redhat.com>
	<20120410204031.ffb5b976225ac9fe6dae474e@gmail.com>
	<4F842074.1050108@linux.vnet.ibm.com>
	<20120411211514.35db29c11460516e604059b6@gmail.com>
	<4F857B61.9080602@linux.vnet.ibm.com>
	<20120411231441.9d0984672dd252b806f99128@gmail.com>
	<4F85936A.6060509@redhat.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2012 17:21:30 +0300
Avi Kivity <avi@redhat.com> wrote:

> Currently the main performance bottleneck for migration is qemu, which
> is single threaded and generally inefficient.  However I am sure that
> once the qemu bottlenecks will be removed we'll encounter kvm problems,
> particularly with wide (many vcpus) and large (lots of memory) guests. 
> So it's a good idea to improve in this area.  I agree we'll need to
> measure each change, perhaps with a test program until qemu catches up.

I agree.

I am especially interested in XBRLE + current srcu-less.

> > I am testing the current live migration to see when and for what it can
> > be used.  I really want to see it become stable and usable for real
> > services.

> Well, it's used in production now.

About RHEL6 e.g., yes of course and we are ...

My comment was about the current srcu-less and whether I can make it enough
stable in this rc-cycle.  I think it will enlarge real use cases in some
extent.

> > So I really do not want to see drastic change now without any real need
> > or feedback from real users -- this is my point.

> It's a good point, we should avoid change for its own sake.

Yes, especially because live migration users are limited to those who have
such services.

I hope that kernel developers start using it in their desktops!!!???

Thanks,
	Takuya
