Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab1KFRK6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 12:10:58 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64814 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab1KFRK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 12:10:57 -0500
Message-ID: <4EB6BF9E.1010309@codemonkey.ws>
Date: Sun, 06 Nov 2011 11:10:54 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Lightning/1.0b2 Thunderbird/3.1.13
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Qemu-devel] [PATCH] KVM: Add wrapper script around QEMU to test
 kernels
References: <1320543320-32728-1-git-send-email-agraf@suse.de>	<CAOJsxLENwuDgt1S2O8XMsgp9uet92gWeS=GFP_6QgW2w7bRQrw@mail.gmail.com>	<4EB65C5B.8070709@redhat.com>	<CAOJsxLEi9TU7zHzcH8KScMNm3CRyJA=ANR3ujWX3cqGFqkUxJw@mail.gmail.com>	<4EB66036.4080102@redhat.com> <1320577728.1428.73.camel@jaguar>	<4EB67486.1070105@redhat.com>	<CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com>	<4EB67D17.7000701@redhat.com>	<CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com>	<4EB680D9.2070706@redhat.com> <CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com>
In-Reply-To: <CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2011 07:06 AM, Pekka Enberg wrote:
> On Sun, Nov 6, 2011 at 2:43 PM, Avi Kivity<avi@redhat.com>  wrote:
>> You say that kvm-tool's scope is broader than Alex's script, therefore
>> the latter is pointless.
>
> I'm saying that Alex's script is pointless because it's not attempting
> to fix the real issues. For example, we're trying to make make it as
> easy as possible to setup a guest and to be able to access guest data
> from the host. Alex's script is essentially just a simplified QEMU
> "front end" for kernel developers.
>
> That's why I feel it's a pointless thing to do.
>
> On Sun, Nov 6, 2011 at 2:43 PM, Avi Kivity<avi@redhat.com>  wrote:
>> You accept that qemu's scope is broader than kvm-tool (and is a
>> superset).  That is why many people think kvm-tool is pointless.
>
> Sure. I think it's mostly people that are interested in non-Linux
> virtualization that think the KVM tool is a pointless project.
> However, some people (including myself) think the KVM tool is a more
> usable and hackable tool than QEMU for Linux virtualization.

There are literally dozens of mini operating systems that exist for exactly the 
same reason that you describe above.  They are smaller and easier to hack on 
than something like Linux.

Regards,

Anthony Liguori

>
> The difference here is that although I feel Alex's script is a
> pointless project, I'm in no way opposed to merging it in the tree if
> people use it and it solves their problem. Some people seem to be
> violently opposed to merging the KVM tool and I'm having difficult
> time understanding why that is.
>
>                          Pekka
>

