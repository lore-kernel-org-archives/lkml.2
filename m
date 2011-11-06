Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab1KFRIP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 12:08:15 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56353 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab1KFRIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 12:08:14 -0500
Message-ID: <4EB6BEFA.6000303@codemonkey.ws>
Date: Sun, 06 Nov 2011 11:08:10 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Lightning/1.0b2 Thunderbird/3.1.13
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Pekka Enberg <penberg@kernel.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Qemu-devel] [PATCH] KVM: Add wrapper script around QEMU to test
 kernels
References: <1320543320-32728-1-git-send-email-agraf@suse.de>	<CAOJsxLENwuDgt1S2O8XMsgp9uet92gWeS=GFP_6QgW2w7bRQrw@mail.gmail.com>	<4EB65C5B.8070709@redhat.com>	<CAOJsxLEi9TU7zHzcH8KScMNm3CRyJA=ANR3ujWX3cqGFqkUxJw@mail.gmail.com>	<4EB66036.4080102@redhat.com> <1320577728.1428.73.camel@jaguar>	<4EB67486.1070105@redhat.com>	<CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com>	<4EB67D17.7000701@redhat.com>	<CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com>	<4EB680D9.2070706@redhat.com>	<CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com>	<4EB6AE34.2000907@redhat.com>	<CAOJsxLFGAnNL9uA=WHD8eJVs5V2+BSrtC+3ff2FsPi326dtjZw@mail.gmail.com> <4EB6BAED.2030400@redhat.com>
In-Reply-To: <4EB6BAED.2030400@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2011 10:50 AM, Avi Kivity wrote:
> On 11/06/2011 06:35 PM, Pekka Enberg wrote:
>>>> The difference here is that although I feel Alex's script is a
>>>> pointless project, I'm in no way opposed to merging it in the tree if
>>>> people use it and it solves their problem. Some people seem to be
>>>> violently opposed to merging the KVM tool and I'm having difficult
>>>> time understanding why that is.
>>>
>>> One of the reasons is that if it is merge, anyone with a #include
>>> <linux/foo.h>  will line up for the next merge window, wanting in.  The
>>> other is that anything in the Linux source tree might gain an unfair
>>> advantage over out-of-tree projects (at least that's how I read Jan's
>>> comment).
>>
>> Well, having gone through the process of getting something included so
>> far, I'm not at all worried that there's going to be a huge queue of
>> "#include<linux/foo.h>" projects if we get in...
>>
>> What kind of unfair advantage are you referring to? I've specifically
>> said that the only way for KVM tool to become a reference
>> implementation would be that the KVM maintainers take the tool through
>> their tree. As that's not going to happen, I don't see what the
>> problem would be.
>
> I'm not personally worried about it either (though in fact a *minimal*
> reference implementation might not be a bad idea).  There's the risk of
> getting informed in-depth press reviews ("Linux KVM Takes A Step Back
>  From Running Windows Guests"), or of unfairly drawing developers away
> from competing projects.

I don't think that's really a concern.  Competition is a good thing.  QEMU is a 
large code base that a lot of people rely upon.  It's hard to take big risks in 
a project like QEMU because the consequences are too high.

OTOH, a project like KVM tool can take a lot of risks.  They've attempted a very 
different command line syntax and they've put a lot of work into making 
virtio-9p a main part of the interface.

If it turns out that these things end up working out well for them, then it 
becomes something we can copy in QEMU.  If not, then we didn't go through the 
train wreck of totally changing CLI syntax only to find it was the wrong syntax.

I'm quite happy with KVM tool and hope they continue working on it.  My only 
real wish is that they wouldn't copy QEMU so much and would try bolder things 
that are fundamentally different from QEMU.

Regards,

Anthony Liguori

>

