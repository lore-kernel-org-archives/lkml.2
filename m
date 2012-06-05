Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933060Ab2FEBHN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 21:07:13 -0400
Received: from ozlabs.org ([203.10.76.45]:41859 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757497Ab2FEBHJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 21:07:09 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Josh Boyer <jwboyer@gmail.com>
Cc: David Howells <dhowells@redhat.com>, kyle@mcmartin.ca,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org
Subject: Re: [PATCH 00/23] Crypto keys and module signing
In-Reply-To: <CA+5PVA4Trq-OEk6pwf5R4vr76zOSn=pmRJU=B6XHEzyOhS3UBw@mail.gmail.com>
References: <8762blyedn.fsf@rustcorp.com.au> <87obpfxdpr.fsf@rustcorp.com.au> <20120522230218.24007.3556.stgit@warthog.procyon.org.uk> <7474.1337782847@redhat.com> <5107.1337868051@redhat.com> <87r4u6w58c.fsf@rustcorp.com.au> <CA+5PVA5qCiYNppOBihKfsqvyNWwBsBsyGD7SmJaphV_67HG1aQ@mail.gmail.com> <87lik33mi6.fsf@rustcorp.com.au> <CA+5PVA4Trq-OEk6pwf5R4vr76zOSn=pmRJU=B6XHEzyOhS3UBw@mail.gmail.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 05 Jun 2012 09:53:30 +0930
Message-ID: <8762b6k3nh.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2012 09:38:43 -0400, Josh Boyer <jwboyer@gmail.com> wrote:
> On Sun, Jun 3, 2012 at 9:16 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > Mangling a module after it is signed is very odd, and odd things aren't
> > nice for security features.  That's how we got here; I'm trying to move
> > the oddness out of the verification path.
> 
> It's unfortunate, yes.  The biggest case I can think of is splitting
> the debug symbols out of the modules after they are built (David might
> have other cases).  Perhaps we could upstream that as well and
> organize it such that the modules are built, split for debuginfo, and
> then signed?

That was my original suggestion.  Just prepare all the module variants
at build time, and sign them all.

See: https://lkml.org/lkml/2011/12/10/16

Cheers,
Rusty.
