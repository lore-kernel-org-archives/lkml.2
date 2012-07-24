Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab2GXWi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 18:38:56 -0400
Received: from gate.crashing.org ([63.228.1.57]:38884 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755368Ab2GXWiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 18:38:55 -0400
Message-ID: <1343169516.3715.25.camel@pasglop>
Subject: Re: [GIT PULL] KVM updates for the 3.6 merge window
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
        Alexander Graf <agraf@suse.de>
Date: Wed, 25 Jul 2012 08:38:36 +1000
In-Reply-To: <CA+55aFygKruOf1G5bjfE3mpvaMP3B7Eg3Hh2=HpMO=M8fDX=tw@mail.gmail.com>
References: <500D1573.3030406@redhat.com>
	 <CA+55aFygKruOf1G5bjfE3mpvaMP3B7Eg3Hh2=HpMO=M8fDX=tw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-24 at 12:04 -0700, Linus Torvalds wrote:
> Ok, this caused conflicts with the s390 and ppc trees. I think I fixed
> them correctly, but the respective arch people really should take a
> look.

A quick peek at the merge commit looks allright, but Alex mentioned that
there's some more fallover that needs an actual patch to fix (the
changes to enforce a cleaner ASM syntax need to be applied to some new
code from Avi's tree that didn't actually trigger merge conflicts).

I'll follow up with Alex and send you the relevant patches if any.

Cheers,
Ben.

>                   Linus
> 
> On Mon, Jul 23, 2012 at 2:12 AM, Avi Kivity <avi@redhat.com> wrote:
> > Linus, please pull from the repo and tag at:
> >
> >   git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/kvm-3.6-1
> >
> > to merge the KVM updates for the 3.5 merge window.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


