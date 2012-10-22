Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab2JVKRY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 06:17:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245Ab2JVKRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 06:17:23 -0400
Date: Mon, 22 Oct 2012 12:16:45 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Christoph Hellwig <hch@infradead.org>,
        Dave Airlie <airlied@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Asias He <asias.hejun@gmail.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [GIT PULL] Linux KVM tool for v3.7-rc0
Message-ID: <20121022101645.GL29310@redhat.com>
References: <20121016134129.2fcd7c8ebe1235065aea929e@canb.auug.org.au>
 <CA+55aFzz66Y1MtOoqEMrQCVzdL-2pgr43e1sXUa=eM5GXL9XSA@mail.gmail.com>
 <20121020180436.c42b7325431fe87104b008fa@canb.auug.org.au>
 <20121020181425.GA11191@liondog.tnic>
 <CAPM=9twcHxUGgYUc27DV1AcYZbzKSbA1Bru8vK1kcWvcG0Jpkw@mail.gmail.com>
 <20121021110329.GA7024@infradead.org>
 <20121021125933.GC19535@gmail.com>
 <CAFLxGvzLOa-BibZ39_yMEC70AseEPbtjcNGk6jLwaAVsU2ujwA@mail.gmail.com>
 <CAOJsxLGm+Qd132i2c7q9p1_yweLiRzC4GR0-Xmx79m2==4_FAw@mail.gmail.com>
 <508510C3.2020901@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508510C3.2020901@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 11:24:19AM +0200, Avi Kivity wrote:
> On 10/21/2012 05:39 PM, Pekka Enberg wrote:
> > 
> > On Sun, Oct 21, 2012 at 5:02 PM, richard -rw- weinberger
> > <richard.weinberger@gmail.com> wrote:
> >> qemu supports all these features.
> >> E.g. to access the host fs use:
> >> qemu ... \
> >>   -fsdev local,security_model=passthrough,id=fsdev-root,path=/your/root/,readonly
> >> \
> >>   -device virtio-9p-pci,id=fs-root,fsdev=fsdev-root,mount_tag=rootshare
> > 
> > IIRC, QEMU uses SLIRP non-root zero-config networking which is much
> > more limited than what LKVM offers out of the box.
> 
> Curious, what are the differences?
> 
Me too, especially as we discussed replacing SLIRP with lkvm code for
userspace networking and decided (for reasons I do not remember) that it
lacks futures SLIRP has. Was it host port redirection?

--
			Gleb.
