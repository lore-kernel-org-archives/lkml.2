Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337Ab1GYMWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 08:22:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970Ab1GYMWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 08:22:09 -0400
Message-ID: <4E2D608F.6020606@redhat.com>
Date: Mon, 25 Jul 2011 14:24:47 +0200
From: Kevin Wolf <kwolf@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Alexander Graf <agraf@suse.de>, Ingo Molnar <mingo@elte.hu>,
        Jan Kiszka <jan.kiszka@web.de>, torvalds@linux-foundation.org,
        avi@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, gorcunov@gmail.com,
        levinsasha928@gmail.com, asias.hejun@gmail.com,
        prasadjoshi124@gmail.com
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
References: <alpine.DEB.2.00.1107242335580.18045@tiger> <4E2CA6DE.4040900@web.de> <CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com> <20110725075305.GA32294@elte.hu> <0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de> <CAOJsxLHGgpNrHpfnHzD-aOJakE9q_4ym51_AYQHaj+waEZtSuw@mail.gmail.com>
In-Reply-To: <CAOJsxLHGgpNrHpfnHzD-aOJakE9q_4ym51_AYQHaj+waEZtSuw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 25.07.2011 10:30, schrieb Pekka Enberg:
> Hi Alexander,
> 
> On Mon, Jul 25, 2011 at 11:14 AM, Alexander Graf <agraf@suse.de> wrote:
>>> So i wanted to have a lightweight tool that allows me to test KVM and
>>> tools/kvm/ does that very nicely: i type './kvm run' and i can test a
>>> native bzImage (which has some virtualization options enabled as
>>> well) on the _host_ distro i am running, booting to a text shell
>>> prompt.
>>
>> I do that all the time.
>>
>>  $ qemu-kvm -nographic -kernel arch/x86/boot/bzImage -append console=ttyS0
>>
>> does the exact same thing. If that's too much typing for you, make it a bash alias.
> 
> You know, they said the same thing about oprofile. All you needed to do was to
> write few simple shell scripts to make it work. One of the key
> features of tools/kvm
> is 'as little configuration as possible' and I can assure you that
> bash alias is really
> not a solution for that.

You've just chosen a different default. I'd argue that most users (i.e.
not developers of the tool or the kernel) actually want to run with a
disk image and graphics. You can type "qemu-kvm harddisk.img" and that's
it. This is clearly superior to something as tedious as "./kvm run -d
harddisk.img --sdl" and I can assure you that a bash alias is really not
a solution for that.

So, as always, which set of command line switches works better for you
depends entirely on your use case.

Kevin
