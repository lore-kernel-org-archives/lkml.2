Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab2JUL3h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 07:29:37 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56457 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab2JUL3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 07:29:36 -0400
MIME-Version: 1.0
In-Reply-To: <20121021111832.GB6504@liondog.tnic>
References: <alpine.LFD.2.02.1210121434140.10531@tux.localdomain>
	<20121016134129.2fcd7c8ebe1235065aea929e@canb.auug.org.au>
	<CA+55aFzz66Y1MtOoqEMrQCVzdL-2pgr43e1sXUa=eM5GXL9XSA@mail.gmail.com>
	<20121020180436.c42b7325431fe87104b008fa@canb.auug.org.au>
	<20121020181425.GA11191@liondog.tnic>
	<CAPM=9twcHxUGgYUc27DV1AcYZbzKSbA1Bru8vK1kcWvcG0Jpkw@mail.gmail.com>
	<20121021111832.GB6504@liondog.tnic>
Date: Sun, 21 Oct 2012 13:29:35 +0200
Message-ID: <CAFLxGvzz4eS5Rd3b4mX4wef-2mnh-aNVrjty6F6vSmwkgdqWaA@mail.gmail.com>
Subject: Re: [GIT PULL] Linux KVM tool for v3.7-rc0
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Borislav Petkov <bp@alien8.de>, Dave Airlie <airlied@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 21, 2012 at 1:18 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Sun, Oct 21, 2012 at 01:07:31PM +1000, Dave Airlie wrote:
>> Why couldn't this script just be a wrapper around qemu?
>>
>> I get the kvm developers developing features that isn't ideal, but for
>> the quick boot a kernel tests, I don't see why a well maintained qemu
>> wrapper isn't superior. I hate constructing qemu command lines, but a
>> script in the kernel repo seems like a good idea.
>
> Well, Alex Graf had exactly that but I don't know what happened to it -
> I can't find it upstream at least.
>
> http://lists.gnu.org/archive/html/qemu-devel/2011-08/msg02728.html

Every kernel developer has his own wrapper script to make qemu usable.
IMHO it's time to add such a script to the kernel tree.

-- 
Thanks,
//richard
