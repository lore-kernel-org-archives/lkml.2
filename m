Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab1KUFV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 00:21:59 -0500
Received: from ozlabs.org ([203.10.76.45]:55459 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428Ab1KUFVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 00:21:53 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Miche Baker-Harvey <miche@google.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Anton Blanchard <anton@samba.org>, Amit Shah <amit.shah@redhat.com>,
        Mike Waychison <mikew@google.com>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Eric Northrup <digitaleric@google.com>
Subject: Re: [PATCH v3 2/3] hvc_init(): Enforce one-time initialization.
In-Reply-To: <CAB8RdapbaueyWLJuJDE_ZdvLkRNM4sQHTxgmgO=jrnXZ6YPSmA@mail.gmail.com>
References: <20111108214452.28884.14840.stgit@miche.sea.corp.google.com> <20111108214504.28884.61814.stgit@miche.sea.corp.google.com> <874nybqo0o.fsf@rustcorp.com.au> <CAB8RdapbaueyWLJuJDE_ZdvLkRNM4sQHTxgmgO=jrnXZ6YPSmA@mail.gmail.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 21 Nov 2011 15:31:04 +1030
Message-ID: <87lira9ii7.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Nov 2011 10:57:37 -0800, Miche Baker-Harvey <miche@google.com> wrote:
> Rusty, Michael, Stephen, et al,
> 
> Thanks for your comments on these patches.
> 
> For what I'm trying to do, all three patches are necessary, but maybe
> I'm going about it the wrong way. Your input would be appreciated.
> I'm in no way claiming that these patches are "right", just that it's
> working for me, and that what's in the current pool is not.

We have to *understand* the code.  If we don't, we need to rewrite the
code so we *do* understand it, or make way for someone who does.

I'm looking at the kvm man page to try to figure out how to have virtio
console, and it's deeply unclear.  What kvm commandline are you using?
I'll try to debug it here, and see what I learn about hvc_console.

Cheers,
Rusty.
