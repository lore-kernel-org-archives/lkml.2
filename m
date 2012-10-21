Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab2JUPDM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 11:03:12 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:48141 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab2JUPDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 11:03:11 -0400
Date: Sun, 21 Oct 2012 17:03:05 +0200
From: Ingo Molnar <mingo@kernel.org>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Airlie <airlied@gmail.com>,
        Borislav Petkov <bp@alien8.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Linux KVM tool for v3.7-rc0
Message-ID: <20121021150305.GA26108@gmail.com>
References: <alpine.LFD.2.02.1210121434140.10531@tux.localdomain>
 <20121016134129.2fcd7c8ebe1235065aea929e@canb.auug.org.au>
 <CA+55aFzz66Y1MtOoqEMrQCVzdL-2pgr43e1sXUa=eM5GXL9XSA@mail.gmail.com>
 <20121020180436.c42b7325431fe87104b008fa@canb.auug.org.au>
 <20121020181425.GA11191@liondog.tnic>
 <CAPM=9twcHxUGgYUc27DV1AcYZbzKSbA1Bru8vK1kcWvcG0Jpkw@mail.gmail.com>
 <20121021110329.GA7024@infradead.org>
 <20121021125933.GC19535@gmail.com>
 <CAFLxGvzLOa-BibZ39_yMEC70AseEPbtjcNGk6jLwaAVsU2ujwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvzLOa-BibZ39_yMEC70AseEPbtjcNGk6jLwaAVsU2ujwA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* richard -rw- weinberger <richard.weinberger@gmail.com> wrote:

> qemu supports all these features.
> E.g. to access the host fs use:
> qemu ... \
>   -fsdev local,security_model=passthrough,id=fsdev-root,path=/your/root/,readonly
> \
>   -device virtio-9p-pci,id=fs-root,fsdev=fsdev-root,mount_tag=rootshare

The best way to compare them would be a script that gives 
exactly the same test environment that 'vm run' / 'vm sandbox' 
does out of box, but using qemu.
 
If such a script is available then that would certainly be a 
useful testing option to kernel developers.

Thanks,

	Ingo
