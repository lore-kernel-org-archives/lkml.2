Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968256Ab2ESAx6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 20:53:58 -0400
Received: from ozlabs.org ([203.10.76.45]:38966 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754420Ab2ESAxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 20:53:55 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Howells <dhowells@redhat.com>
Cc: kyle@mcmartin.ca, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org
Subject: Re: [PATCH 00/29] Crypto keys and module signing [ver #4]
In-Reply-To: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
References: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Sat, 19 May 2012 10:23:05 +0930
Message-ID: <87ipft3sb2.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2012 00:39:01 +0100, David Howells <dhowells@redhat.com> wrote:
> 
> Hi Rusty,
> 
> Here's my latest take on my module signing patch set.  I've retained my
> strip-proof[*] signature-in-module concept, but I've shrunk the module
> verification code by nearly half.  Its .text segment now stands at just over 2K
> in size for an x86_64 kernel.

Hi David!

        I get it.  Some management bigwig at RH has told you to get this
patch in, right?  And you told them it'd had been Nacked, that the
maintainer had said it was never going in, and of course, that it was a
stupid idea and to give up on the idea of stripping modules after
signing, and just append a magic marker and the signature.

        But they just wouldn't listen, would they?  So you had to waste
your time polishing this turd, until you annoy me enough to get the kind
of flaming rejection which is visible from space and chars the eyeballs
of your manager so they understand.

        Well, here it is.  I even put it in caps for you!

NAK.  THIS PATCH WILL NEVER, EVER GO IN.  I AM NOT PUTTING CRAP IN THE
KERNEL BECAUSE RH CAN'T FIGURE OUT HOW TO PRODUCE STRIPPED VERSIONS OF
MODULES DURING BUILD.  DON'T BE TOO PROUD OF THIS TECHNOLOGICAL TERROR
YOU'VE CONSTRUCTED.

I look forward to you updated patch series!
Rusty.
