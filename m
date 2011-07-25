Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480Ab1GYIb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 04:31:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60922 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab1GYIby convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 04:31:54 -0400
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <CAOJsxLFv74GaBpNkVSWpEpqs505smUb2yBrMAh7UY_ggVWPwFA@mail.gmail.com>
Date: Mon, 25 Jul 2011 10:31:51 +0200
Cc: Ingo Molnar <mingo@elte.hu>, Jan Kiszka <jan.kiszka@web.de>,
        torvalds@linux-foundation.org, avi@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gorcunov@gmail.com, levinsasha928@gmail.com,
        asias.hejun@gmail.com, prasadjoshi124@gmail.com
Content-Transfer-Encoding: 8BIT
Message-Id: <ECCD7C67-C339-43EA-8A57-513173899813@suse.de>
References: <alpine.DEB.2.00.1107242335580.18045@tiger> <4E2CA6DE.4040900@web.de> <CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com> <20110725075305.GA32294@elte.hu> <0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de> <CAOJsxLFv74GaBpNkVSWpEpqs505smUb2yBrMAh7UY_ggVWPwFA@mail.gmail.com>
To: Pekka Enberg <penberg@kernel.org>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 25.07.2011, at 10:23, Pekka Enberg wrote:

> Hi Alexander,
> 
> On Mon, Jul 25, 2011 at 11:14 AM, Alexander Graf <agraf@suse.de> wrote:
>>> Same here - in fact i first asked Qemu to be put into tools/qemu/ so
>>> that it all becomes more hackable and more usable - that suggestion
>>> was rebuked very strongly.
>> 
>> So instead of thinking a bit and trying to realize that there might be a reason people don't want all their user space in the kernel tree you go ahead and start your own crusade of creating a new user space. Great. That's how I always hoped Linux would be :(.
> 
> Damn you Ingo Molnar, I knew you'd somehow get all the credit for our
> hard work! ;-)

Well, IIUC he's the one initiating the whole thing, no?

> More seriously, though, I fail to see what's bothering you Alexander.
> I and Ingo already mentioned we wouldn't be hacking on Qemu even if
> there wasn't no tools/kvm. It's not as if we're putting *your* user
> space code into the kernel tree - we wrote our own! What's wrong with
> that?

Nothing. I like competition. But why push it into the kernel? It's not a kernel, it's not a library the kernels needs for internal stuff. So why would it have to be in there?

In Ingo's reasoning, the next step would be to rewrite glibc and put it into the kernel tree, because we end up adding syscalls so adding them to the in-kernel libc with the same commit would be a lot easier and cleaner.


Alex

