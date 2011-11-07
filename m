Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab1KGLin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 06:38:43 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43720 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab1KGLil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 06:38:41 -0500
Date: Mon, 7 Nov 2011 13:38:29 +0200 (EET)
From: Pekka Enberg <penberg@cs.helsinki.fi>
X-X-Sender: penberg@tux.localdomain
To: Kevin Wolf <kwolf@redhat.com>
cc: "Ted Ts'o" <tytso@mit.edu>, Anthony Liguori <anthony@codemonkey.ws>,
        Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Qemu-devel] [PATCH] KVM: Add wrapper script around QEMU to test
 kernels
In-Reply-To: <4EB7B375.4090904@redhat.com>
Message-ID: <alpine.LFD.2.02.1111071335140.2815@tux.localdomain>
References: <4EB67486.1070105@redhat.com> <CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com> <4EB67D17.7000701@redhat.com> <CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com> <4EB680D9.2070706@redhat.com>
 <CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com> <4EB6AE34.2000907@redhat.com> <CAOJsxLFGAnNL9uA=WHD8eJVs5V2+BSrtC+3ff2FsPi326dtjZw@mail.gmail.com> <4EB6BAED.2030400@redhat.com> <4EB6BEFA.6000303@codemonkey.ws> <20111106183132.GA4500@thunk.org>
 <4EB7B375.4090904@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Nov 2011, Kevin Wolf wrote:
> Makes it a lot less hackable for me unless you want to restrict the set
> of potential developers to Linux kernel developers...

We're not restricting potential developers to Linux kernel folks. We're 
making it easy for them because we believe that the KVM tool is a 
userspace component that requires the kind of low-level knowledge Linux 
kernel developers have.

I think you're looking at the KVM tool with your QEMU glasses on without 
realizing that there's no point in comparing the two: we only support 
Linux on Linux and we avoid hardware emulation as much as possible. So 
what makes sense for QEMU, doesn't necessarily translate to the KVM tool 
project.

 			Pekka
