Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639Ab1GYIhS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 04:37:18 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50685 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab1GYIhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 04:37:13 -0400
MIME-Version: 1.0
In-Reply-To: <ECCD7C67-C339-43EA-8A57-513173899813@suse.de>
References: <alpine.DEB.2.00.1107242335580.18045@tiger>
	<4E2CA6DE.4040900@web.de>
	<CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com>
	<20110725075305.GA32294@elte.hu>
	<0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de>
	<CAOJsxLFv74GaBpNkVSWpEpqs505smUb2yBrMAh7UY_ggVWPwFA@mail.gmail.com>
	<ECCD7C67-C339-43EA-8A57-513173899813@suse.de>
Date: Mon, 25 Jul 2011 11:37:12 +0300
X-Google-Sender-Auth: -zYzAJfpFscj5uc8EO1SWXbrdwo
Message-ID: <CAOJsxLEmsSAHvKSX-Et0Q7cq+RgvgfuspWB3GamaBN-fRDq_mw@mail.gmail.com>
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
From: Pekka Enberg <penberg@kernel.org>
To: Alexander Graf <agraf@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Jan Kiszka <jan.kiszka@web.de>,
        torvalds@linux-foundation.org, avi@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gorcunov@gmail.com, levinsasha928@gmail.com,
        asias.hejun@gmail.com, prasadjoshi124@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

On Mon, Jul 25, 2011 at 11:31 AM, Alexander Graf <agraf@suse.de> wrote:
>> Damn you Ingo Molnar, I knew you'd somehow get all the credit for our
>> hard work! ;-)
>
> Well, IIUC he's the one initiating the whole thing, no?

As much as I appreciate Ingo's help and support with the project, no,
I don't consider him to have initiated the whole thing. Yes, it's his
idea and that's what got me into hacking on the thing in the first
place. But calling this Ingo's crusade is somewhat missing the point.
It's really people like Asias, Sasha, Cyrill, and Prashad who have
made all the heavy lifting.

On Mon, Jul 25, 2011 at 11:31 AM, Alexander Graf <agraf@suse.de> wrote:
>> More seriously, though, I fail to see what's bothering you Alexander.
>> I and Ingo already mentioned we wouldn't be hacking on Qemu even if
>> there wasn't no tools/kvm. It's not as if we're putting *your* user
>> space code into the kernel tree - we wrote our own! What's wrong with
>> that?
>
> Nothing. I like competition. But why push it into the kernel? It's not a kernel, it's not a library the kernels needs for internal stuff. So why would it have to be in there?

For the same reasons we want tools/perf to be there.

On Mon, Jul 25, 2011 at 11:31 AM, Alexander Graf <agraf@suse.de> wrote:
> In Ingo's reasoning, the next step would be to rewrite glibc and put it into the kernel tree, because we end up adding syscalls so adding them to the in-kernel libc with the same commit would be a lot easier and cleaner.

It's called klibc, btw. :-)

                                Pekka
