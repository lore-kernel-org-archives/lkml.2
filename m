Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab2GMPpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 11:45:39 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34162 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab2GMPph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 11:45:37 -0400
MIME-Version: 1.0
In-Reply-To: <4FFEBB39.8090308@redhat.com>
References: <4FFEBB39.8090308@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Jul 2012 08:45:15 -0700
X-Google-Sender-Auth: QnzXreu2ZMzQ4yKL2jKLOTuoiQc
Message-ID: <CA+55aFwAXbrQRKg_cJT04H_XnoEPjJ0O711C5uA6fRY35DVhKQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM fixes for 3.5-rc6
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Missing diffstat. Please please *please* always make sure you have
diffstats, because I really want to know that what I'm pulling matches
what you *think* that I'm pulling. And the diffstat isn't just for me
- it hopefully really makes you look at the whole "this is what I'm
asking Linus to pull" thing too.

              Linus

On Thu, Jul 12, 2012 at 4:55 AM, Avi Kivity <avi@redhat.com> wrote:
> Linus, please pull a couple of KVM fixes from:
>
>   git://git.kernel.org/pub/scm/virt/kvm/kvm.git master
>
> One is an adjustment for an irq layer change that affected device
> assignment, the other a one-liner ppc fix.
>
> ----------------------------------------------------------------
>
> Alex Williamson (1):
>       KVM: Fix device assignment threaded irq handler
>
> Avi Kivity (1):
>       Merge branch 'for-upstream-master' of git://github.com/agraf/linux-2.6
>
> Benjamin Herrenschmidt (1):
>       powerpc/kvm: Fix "PR" KVM implementation of H_CEDE
>
> --
> error compiling committee.c: too many arguments to function
>
