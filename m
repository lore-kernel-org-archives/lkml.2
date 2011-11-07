Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab1KGBi1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 20:38:27 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45731 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab1KGBiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 20:38:25 -0500
Message-ID: <4EB7368D.1080003@codemonkey.ws>
Date: Sun, 06 Nov 2011 19:38:21 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Lightning/1.0b2 Thunderbird/3.1.13
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        Avi Kivity <avi@redhat.com>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Qemu-devel] [PATCH] KVM: Add wrapper script around QEMU to test
 kernels
References: <1320543320-32728-1-git-send-email-agraf@suse.de>	<CAOJsxLENwuDgt1S2O8XMsgp9uet92gWeS=GFP_6QgW2w7bRQrw@mail.gmail.com>	<4EB65C5B.8070709@redhat.com>	<CAOJsxLEi9TU7zHzcH8KScMNm3CRyJA=ANR3ujWX3cqGFqkUxJw@mail.gmail.com>	<4EB66036.4080102@redhat.com> <1320577728.1428.73.camel@jaguar>	<4EB67486.1070105@redhat.com>	<CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com>	<4EB67D17.7000701@redhat.com>	<CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com>	<4EB680D9.2070706@redhat.com>	<CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com>	<4EB6AE34.2000907@redhat.com>	<CAOJsxLFGAnNL9uA=WHD8eJVs5V2+BSrtC+3ff2FsPi326dtjZw@mail.gmail.com>	<4EB6BAED.2030400@redhat.com> <4EB6BEFA.6000303@codemonkey.ws> <CAOJsxLFApM9D_29h+qbU+npJgjKbOVvMBvftvHpmWwSqzE=Pkw@mail.gmail.com>
In-Reply-To: <CAOJsxLFApM9D_29h+qbU+npJgjKbOVvMBvftvHpmWwSqzE=Pkw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2011 12:09 PM, Pekka Enberg wrote:
> On Sun, Nov 6, 2011 at 7:08 PM, Anthony Liguori<anthony@codemonkey.ws>  wrote:
>> I'm quite happy with KVM tool and hope they continue working on it.  My only
>> real wish is that they wouldn't copy QEMU so much and would try bolder
>> things that are fundamentally different from QEMU.
>
> Hey, right now our only source of crazy ideas is Ingo and I think he's
> actually a pretty conservative guy when it comes to technology. Avi
> has expressed some crazy ideas in the past but they require switching
> away from C and that's not something we're interested in doing. ;-)

Just a couple random suggestions:

- Drop SDL/VNC.  Make a proper Cairo GUI with a full blown GTK interface.  Don't 
rely on virt-manager for this.  Not that I have anything against virt-manager 
but there are many layers between you and the end GUI if you go that route.

- Sandbox the device model from day #1.  The size of the Linux kernel interface 
is pretty huge and as a hypervisor, it's the biggest place for improvement from 
a security perspective.  We're going to do sandboxing in QEMU, but it's going to 
be difficult.  It would be much easier for you given where you're at.

Regards,

Anthony Liguori

>
>                          Pekka
>

