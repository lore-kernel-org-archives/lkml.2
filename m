Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673Ab1GYJGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 05:06:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35195 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886Ab1GYJGp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 05:06:45 -0400
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <CAOJsxLFDzSg55u92b6Qgvqn1yjaShYG_Bgdkzy19aBrzxo7FqA@mail.gmail.com>
Date: Mon, 25 Jul 2011 11:06:40 +0200
Cc: Ingo Molnar <mingo@elte.hu>, Jan Kiszka <jan.kiszka@web.de>,
        torvalds@linux-foundation.org, avi@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gorcunov@gmail.com, levinsasha928@gmail.com,
        asias.hejun@gmail.com, prasadjoshi124@gmail.com
Content-Transfer-Encoding: 8BIT
Message-Id: <B0466610-8355-402E-B378-68BD3AF9CE2D@suse.de>
References: <alpine.DEB.2.00.1107242335580.18045@tiger> <4E2CA6DE.4040900@web.de> <CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com> <20110725075305.GA32294@elte.hu> <0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de> <CAOJsxLHGgpNrHpfnHzD-aOJakE9q_4ym51_AYQHaj+waEZtSuw@mail.gmail.com> <ED2ECD82-2B14-45FF-AA61-AB26B377B626@suse.de> <CAOJsxLFDzSg55u92b6Qgvqn1yjaShYG_Bgdkzy19aBrzxo7FqA@mail.gmail.com>
To: Pekka Enberg <penberg@kernel.org>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 25.07.2011, at 10:47, Pekka Enberg wrote:

> Hi Alexander,
> 
> On Mon, Jul 25, 2011 at 11:37 AM, Alexander Graf <agraf@suse.de> wrote:
>>>  different direction we're taking. Hell, we even went ahead and wrote our own
>>>  mini-BIOS just to keep things in one unified tree. ]
>> 
>> Yes, making sure that you have even more non-working non-Linux OSs.
> 
> You know, I've been a Linux kernel hacker for more than five years now
> and I've spent way too much of my spare time to improve it. So yes, I
> care about Linux. I care about it a lot, actually. It's fair to say I
> care about Linux more than I care about it more than any other
> operating system out there.
> 
> [ I thought the 'native Linux' part in 'native Linux KVM tool' was a
> dead giveaway, really. ]
> 
> Now if people want to support other operating systems, that's cool and
> I'm happy to help out where I can. But I don't understand why people
> keep bringing non-Linux OSs as an argument for not merging tools/kvm
> into the Linux kernel tree. I mean really, did someone actually expect
> that a Linux kernel developer spends his weekends improving the state
> of Windows virtualization?
> 
> And don't get this the wrong way either, I'm not hostile against other
> operating systems, but I simply am not interested enough in them to
> spend my time improving them.

Then kvm-tool is about as useful as Mac-on-Linux. Why don't we have MoL user land in the kernel? I even added support for KVM to it about a year ago. So all I need to do is change it to the kernel coding style, add some dependencies on kernel headers and I'm good for a pull request?


Alex

