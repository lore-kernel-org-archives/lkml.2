Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab2LMWW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 17:22:57 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:38388 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab2LMWW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 17:22:56 -0500
MIME-Version: 1.0
In-Reply-To: <20121213081935.90098f39e6da6ee17e902324@canb.auug.org.au>
References: <20121212123519.GA11549@amt.cnet> <20121213081935.90098f39e6da6ee17e902324@canb.auug.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 13 Dec 2012 14:22:34 -0800
X-Google-Sender-Auth: BVZH8dO24p4BEGRL1n-J5HT6WIw
Message-ID: <CA+55aFxXgEL5997fgzbhvKAUtfTPsUKXpk5MMBKWYpmZzX2JtQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM updates for the 3.8 merge window
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi.kivity@gmail.com>,
        Alexander Graf <agraf@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 1:19 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> There is a section of this tree (the kvm-ppc tree in linux-next) that has
> been rebased before being merged into this tree.   Alexander, please
> don't do that (especially since it has *not* bee rebased in the kvm-ppc
> tree but more work has been added on top of it :-().

Christ, why can't people learn?

Solution: I'm not pulling this, if it means that we will have
duplicate commits somewhere.

              Linus
