Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab1GYToE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 15:44:04 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45996 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab1GYTn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 15:43:59 -0400
MIME-Version: 1.0
In-Reply-To: <4E2DB4ED.4070505@web.de>
References: <alpine.DEB.2.00.1107242335580.18045@tiger>
	<4E2CA6DE.4040900@web.de>
	<CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com>
	<4E2DB4ED.4070505@web.de>
Date: Mon, 25 Jul 2011 22:43:58 +0300
X-Google-Sender-Auth: N4m78OmOtv8chZ9NMKTu50rh03I
Message-ID: <CAOJsxLGvx=PQOqq--26k794SHdjDVOa7vhmNDKQt0jmfLbVRiQ@mail.gmail.com>
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

On Mon, Jul 25, 2011 at 9:24 PM, Jan Kiszka <jan.kiszka@web.de> wrote:
>> On Mon, Jul 25, 2011 at 2:12 AM, Jan Kiszka <jan.kiszka@web.de> wrote:
>>> I've read several times now that developing in a single tree leads to
>>> better results. Can you provide some example from the QEMU/KVM projects
>>> where the split is preventing innovation, optimizations, or some other
>>> kind of progress?
>>
>> I really don't follow the Qemu project well enough to comment on what
>> your biggest pain points are there.
>
> Mmh, you can solve problems you do not even need to know about, just by
> merging them into the kernel? Wait, will send you some more! :)

Don't be an idiot.

Qemu's problems are pretty well understood and many of them explained
in this particular thread. I'm not trying to fix Qemu's problems nor
am I trying to fix your Windows virtualization issues. I'm trying to
implement tooling to support Linux on KVM well enough that I don't
have to use VirtualBox for virtualization myself.

>> As for tools/kvm, it's pretty obvious by now that we want tighter
>> integration with perf and the tracing facilities (and share code!),
>> for example so for us merging to mainline is important.
>
> Tracing&profiling are important topics, but in the end just small pieces
> of the virtualization problem space. If that was the strongest reason,
> it would be like asking gdb guys to merge qemu because it contains a
> gdbserver.

I think that just shows that you don't really understand the benefits
of integrating KVM and perf.

> Anyway. Thanks for all the fish! Found nothing new, not much concrete,
> but many really entertaining answers. So why not repeat this on the next
> merge window?

While it's entertaining for you, it's not so much for me. I think we
have something pretty useful and cool in tools/kvm but all you seem to
want to talk about is Qemu which I personally find pretty
uninteresting.

Anyway, it's really up to Linus. FWIW, Avi doesn't oppose to the
merging and Ingo seems to think it's useful enough to have in -tip.

                        Pekka
