Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab2EMPPZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 11:15:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753511Ab2EMPPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 11:15:22 -0400
Date: Sun, 13 May 2012 18:15:20 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 7/7] kvm: host side for eoi optimization
Message-ID: <20120513151520.GA25752@redhat.com>
References: <cover.1336679924.git.mst@redhat.com>
 <cb4203d10594c055fde1c6fd0b02df1d030fad3b.1336679924.git.mst@redhat.com>
 <20120513093317.GE4296@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120513093317.GE4296@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2012 at 12:33:17PM +0300, Gleb Natapov wrote:
> >  arch/x86/include/asm/kvm_host.h |    6 ++
> >  arch/x86/include/asm/kvm_para.h |    2 +
> >  arch/x86/kvm/cpuid.c            |    1 +
> >  arch/x86/kvm/irq.c              |    2 +-
> >  arch/x86/kvm/lapic.c            |  109 +++++++++++++++++++++++++++++++++++++--
> >  arch/x86/kvm/lapic.h            |    2 +
> >  arch/x86/kvm/trace.h            |   34 ++++++++++++
> >  arch/x86/kvm/x86.c              |    8 +++-
> Documentation ++++++ :)

I just sent out some documentation. Didn't want to
repost the whole patchset to acoid spamming the list,
I hope you and others can use it for review.

Thanks,
MST
