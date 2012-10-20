Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621Ab2JTSOa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 14:14:30 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47155 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756524Ab2JTSO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 14:14:29 -0400
Date: Sat, 20 Oct 2012 20:14:25 +0200
From: Borislav Petkov <bp@alien8.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULL] Linux KVM tool for v3.7-rc0
Message-ID: <20121020181425.GA11191@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121020180436.c42b7325431fe87104b008fa@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 20, 2012 at 06:04:36PM +1100, Stephen Rothwell wrote:
> So are there any compelling arguments from the proponents, or can
> I remove this from linux-next (and have it removed from the tip
> auto-latest branch)?

FWIW, I gave this a run and I have to say, it works as advertized: I
built it and ran it with the latest kernel and the thing simply boots
the kernel. Even without a disk image - the simplest command is:

$ ./lkvm run --kernel ../../arch/x86/boot/bzImage

and it gets me a shell in the vm after a second.

So the absolute advantage it gives kernel devs is that they can
smoke-test whether their stuff boots in seconds.

This is probably not helpful when enabling specific hw features but
should be pretty helpful for generic arch stuff.

HTH.

-- 
Regards/Gruss,
    Boris.
