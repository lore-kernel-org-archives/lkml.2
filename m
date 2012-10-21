Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab2JUDHd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 23:07:33 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:48609 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab2JUDHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 23:07:32 -0400
MIME-Version: 1.0
In-Reply-To: <20121020181425.GA11191@liondog.tnic>
References: <alpine.LFD.2.02.1210121434140.10531@tux.localdomain>
	<20121016134129.2fcd7c8ebe1235065aea929e@canb.auug.org.au>
	<CA+55aFzz66Y1MtOoqEMrQCVzdL-2pgr43e1sXUa=eM5GXL9XSA@mail.gmail.com>
	<20121020180436.c42b7325431fe87104b008fa@canb.auug.org.au>
	<20121020181425.GA11191@liondog.tnic>
Date: Sun, 21 Oct 2012 13:07:31 +1000
Message-ID: <CAPM=9twcHxUGgYUc27DV1AcYZbzKSbA1Bru8vK1kcWvcG0Jpkw@mail.gmail.com>
Subject: Re: [GIT PULL] Linux KVM tool for v3.7-rc0
From: Dave Airlie <airlied@gmail.com>
To: Borislav Petkov <bp@alien8.de>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 21, 2012 at 4:14 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Sat, Oct 20, 2012 at 06:04:36PM +1100, Stephen Rothwell wrote:
>> So are there any compelling arguments from the proponents, or can
>> I remove this from linux-next (and have it removed from the tip
>> auto-latest branch)?
>
> FWIW, I gave this a run and I have to say, it works as advertized: I
> built it and ran it with the latest kernel and the thing simply boots
> the kernel. Even without a disk image - the simplest command is:
>
> $ ./lkvm run --kernel ../../arch/x86/boot/bzImage
>
> and it gets me a shell in the vm after a second.
>
> So the absolute advantage it gives kernel devs is that they can
> smoke-test whether their stuff boots in seconds.
>
> This is probably not helpful when enabling specific hw features but
> should be pretty helpful for generic arch stuff.

Why couldn't this script just be a wrapper around qemu?

I get the kvm developers developing features that isn't ideal, but for
the quick boot a kernel tests, I don't see why a well maintained qemu
wrapper isn't superior. I hate constructing qemu command lines, but a
script in the kernel repo seems like a good idea.

Dave.
