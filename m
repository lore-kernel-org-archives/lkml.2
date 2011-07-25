Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542Ab1GYIa0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 04:30:26 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50449 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab1GYIaV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 04:30:21 -0400
MIME-Version: 1.0
In-Reply-To: <0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de>
References: <alpine.DEB.2.00.1107242335580.18045@tiger>
	<4E2CA6DE.4040900@web.de>
	<CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com>
	<20110725075305.GA32294@elte.hu>
	<0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de>
Date: Mon, 25 Jul 2011 11:30:20 +0300
X-Google-Sender-Auth: gqztLqTyHb8pfg4kP7I7LcHCloo
Message-ID: <CAOJsxLHGgpNrHpfnHzD-aOJakE9q_4ym51_AYQHaj+waEZtSuw@mail.gmail.com>
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
From: Pekka Enberg <penberg@kernel.org>
To: Alexander Graf <agraf@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Jan Kiszka <jan.kiszka@web.de>,
        torvalds@linux-foundation.org, avi@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gorcunov@gmail.com, levinsasha928@gmail.com,
        asias.hejun@gmail.com, prasadjoshi124@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

On Mon, Jul 25, 2011 at 11:14 AM, Alexander Graf <agraf@suse.de> wrote:
>> So i wanted to have a lightweight tool that allows me to test KVM and
>> tools/kvm/ does that very nicely: i type './kvm run' and i can test a
>> native bzImage (which has some virtualization options enabled as
>> well) on the _host_ distro i am running, booting to a text shell
>> prompt.
>
> I do that all the time.
>
>  $ qemu-kvm -nographic -kernel arch/x86/boot/bzImage -append console=ttyS0
>
> does the exact same thing. If that's too much typing for you, make it a bash alias.

You know, they said the same thing about oprofile. All you needed to do was to
write few simple shell scripts to make it work. One of the key
features of tools/kvm
is 'as little configuration as possible' and I can assure you that
bash alias is really
not a solution for that.

[ Yes, yes, I know people apparently use virtio-manager for lauching Qemu so
  they don't need to figure out the setup themselves. But now you have *three*
  separate components (KVM, Qemu, virtio-manager) which is a completely
  different direction we're taking. Hell, we even went ahead and wrote our own
  mini-BIOS just to keep things in one unified tree. ]

                                Pekka
