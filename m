Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab2JULSg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 07:18:36 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37415 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464Ab2JULSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 07:18:35 -0400
Date: Sun, 21 Oct 2012 13:18:32 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dave Airlie <airlied@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULL] Linux KVM tool for v3.7-rc0
Message-ID: <20121021111832.GB6504@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Dave Airlie <airlied@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Pekka Enberg <penberg@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@kernel.org>, Avi Kivity <avi@redhat.com>,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
References: <alpine.LFD.2.02.1210121434140.10531@tux.localdomain>
 <20121016134129.2fcd7c8ebe1235065aea929e@canb.auug.org.au>
 <CA+55aFzz66Y1MtOoqEMrQCVzdL-2pgr43e1sXUa=eM5GXL9XSA@mail.gmail.com>
 <20121020180436.c42b7325431fe87104b008fa@canb.auug.org.au>
 <20121020181425.GA11191@liondog.tnic>
 <CAPM=9twcHxUGgYUc27DV1AcYZbzKSbA1Bru8vK1kcWvcG0Jpkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPM=9twcHxUGgYUc27DV1AcYZbzKSbA1Bru8vK1kcWvcG0Jpkw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 21, 2012 at 01:07:31PM +1000, Dave Airlie wrote:
> Why couldn't this script just be a wrapper around qemu?
>
> I get the kvm developers developing features that isn't ideal, but for
> the quick boot a kernel tests, I don't see why a well maintained qemu
> wrapper isn't superior. I hate constructing qemu command lines, but a
> script in the kernel repo seems like a good idea.

Well, Alex Graf had exactly that but I don't know what happened to it -
I can't find it upstream at least.

http://lists.gnu.org/archive/html/qemu-devel/2011-08/msg02728.html

-- 
Regards/Gruss,
    Boris.
