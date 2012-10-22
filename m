Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab2JVJZE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 05:25:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18591 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252Ab2JVJZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 05:25:03 -0400
Message-ID: <508510C3.2020901@redhat.com>
Date: Mon, 22 Oct 2012 11:24:19 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Christoph Hellwig <hch@infradead.org>,
        Dave Airlie <airlied@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Asias He <asias.hejun@gmail.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [GIT PULL] Linux KVM tool for v3.7-rc0
References: <alpine.LFD.2.02.1210121434140.10531@tux.localdomain> <20121016134129.2fcd7c8ebe1235065aea929e@canb.auug.org.au> <CA+55aFzz66Y1MtOoqEMrQCVzdL-2pgr43e1sXUa=eM5GXL9XSA@mail.gmail.com> <20121020180436.c42b7325431fe87104b008fa@canb.auug.org.au> <20121020181425.GA11191@liondog.tnic> <CAPM=9twcHxUGgYUc27DV1AcYZbzKSbA1Bru8vK1kcWvcG0Jpkw@mail.gmail.com> <20121021110329.GA7024@infradead.org> <20121021125933.GC19535@gmail.com> <CAFLxGvzLOa-BibZ39_yMEC70AseEPbtjcNGk6jLwaAVsU2ujwA@mail.gmail.com> <CAOJsxLGm+Qd132i2c7q9p1_yweLiRzC4GR0-Xmx79m2==4_FAw@mail.gmail.com>
In-Reply-To: <CAOJsxLGm+Qd132i2c7q9p1_yweLiRzC4GR0-Xmx79m2==4_FAw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2012 05:39 PM, Pekka Enberg wrote:
> 
> On Sun, Oct 21, 2012 at 5:02 PM, richard -rw- weinberger
> <richard.weinberger@gmail.com> wrote:
>> qemu supports all these features.
>> E.g. to access the host fs use:
>> qemu ... \
>>   -fsdev local,security_model=passthrough,id=fsdev-root,path=/your/root/,readonly
>> \
>>   -device virtio-9p-pci,id=fs-root,fsdev=fsdev-root,mount_tag=rootshare
> 
> IIRC, QEMU uses SLIRP non-root zero-config networking which is much
> more limited than what LKVM offers out of the box.

Curious, what are the differences?

-- 
error compiling committee.c: too many arguments to function
