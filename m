Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527Ab1GYHh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 03:37:57 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48267 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab1GYHhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 03:37:51 -0400
MIME-Version: 1.0
In-Reply-To: <4E2CA6DE.4040900@web.de>
References: <alpine.DEB.2.00.1107242335580.18045@tiger>
	<4E2CA6DE.4040900@web.de>
Date: Mon, 25 Jul 2011 10:37:50 +0300
X-Google-Sender-Auth: ublcyYxyqv8jMY2Gya1-Zbl8gMc
Message-ID: <CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com>
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
From: Pekka Enberg <penberg@kernel.org>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, avi@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gorcunov@gmail.com, levinsasha928@gmail.com,
        asias.hejun@gmail.com, prasadjoshi124@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

On Mon, Jul 25, 2011 at 2:12 AM, Jan Kiszka <jan.kiszka@web.de> wrote:
> I've read several times now that developing in a single tree leads to
> better results. Can you provide some example from the QEMU/KVM projects
> where the split is preventing innovation, optimizations, or some other
> kind of progress?

I really don't follow the Qemu project well enough to comment on what
your biggest pain points are there.

As for tools/kvm, it's pretty obvious by now that we want tighter
integration with perf and the tracing facilities (and share code!),
for example so for us merging to mainline is important.

On Mon, Jul 25, 2011 at 2:12 AM, Jan Kiszka <jan.kiszka@web.de> wrote:
> Let's assume this gets merged. What will change for people working on
> generic or x86 KVM features? Will they sooner or later be asked to
> provide corresponding bits also for the tools folder? Having worked on
> two userlands over the past years (QEMU and qemu-kvm), still
> contributing to finally unify them, I'm wondering if this will end up
> repeating the painful history.

I'm not a KVM maintainer so I really don't know how tools/kvm will
change any of the above things. I'm certainly not in a position to
*require* anyone to update tools/kvm when they add new KVM features
but it'd sure be great.

On Mon, Jul 25, 2011 at 2:12 AM, Jan Kiszka <jan.kiszka@web.de> wrote:
> That said, I definitely appreciate the bug fixes as well as code and
> documentation improvements for KVM that originate from this effort! I'm
> just not convinced that writing a new userland and merging it into the
> kernel is the most efficient way to achieve that.

Just to make this crystal clear for everyone: if it weren't for
tools/kvm, I wouldn't be hacking on KVM at all. I've looked at Qemu in
the past (and a lot recently!) and I simply don't see myself
contributing to it, sorry. So 'most efficient' or not, I think
tools/kvm is a net win for Linux and KVM in general.

                        Pekka
