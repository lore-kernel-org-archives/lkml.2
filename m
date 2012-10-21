Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab2JURPr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 13:15:47 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40451 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397Ab2JURPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 13:15:46 -0400
Date: Sun, 21 Oct 2012 19:15:43 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Christoph Hellwig <hch@infradead.org>, Dave Airlie <airlied@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Linux KVM tool for v3.7-rc0
Message-ID: <20121021171543.GC20642@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@kernel.org>,
	richard -rw- weinberger <richard.weinberger@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Airlie <airlied@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Pekka Enberg <penberg@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org
References: <alpine.LFD.2.02.1210121434140.10531@tux.localdomain>
 <20121016134129.2fcd7c8ebe1235065aea929e@canb.auug.org.au>
 <CA+55aFzz66Y1MtOoqEMrQCVzdL-2pgr43e1sXUa=eM5GXL9XSA@mail.gmail.com>
 <20121020180436.c42b7325431fe87104b008fa@canb.auug.org.au>
 <20121020181425.GA11191@liondog.tnic>
 <CAPM=9twcHxUGgYUc27DV1AcYZbzKSbA1Bru8vK1kcWvcG0Jpkw@mail.gmail.com>
 <20121021110329.GA7024@infradead.org>
 <20121021125933.GC19535@gmail.com>
 <CAFLxGvzLOa-BibZ39_yMEC70AseEPbtjcNGk6jLwaAVsU2ujwA@mail.gmail.com>
 <20121021150305.GA26108@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121021150305.GA26108@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 21, 2012 at 05:03:05PM +0200, Ingo Molnar wrote:
> The best way to compare them would be a script that gives exactly the
> same test environment that 'vm run' / 'vm sandbox' does out of box,
> but using qemu.
>
> If such a script is available then that would certainly be a useful
> testing option to kernel developers.

Right,

I gotta say, I've mucked around with qemu/kvm net options as a novice
user and haven't always been successfu. If you get host networking
straight away in lkvm then that's another clear point for tools/kvm.

Same holds true for copying data back and forth between host and guest.

Thanks.

-- 
Regards/Gruss,
    Boris.
