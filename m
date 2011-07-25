Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723Ab1GYMwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 08:52:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48049 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab1GYMv6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 08:51:58 -0400
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <4E2D65D7.6030407@redhat.com>
Date: Mon, 25 Jul 2011 14:51:54 +0200
Cc: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Jan Kiszka <jan.kiszka@web.de>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gorcunov@gmail.com, levinsasha928@gmail.com,
        asias.hejun@gmail.com, prasadjoshi124@gmail.com
Content-Transfer-Encoding: 8BIT
Message-Id: <0747BB86-5A2E-449D-BF03-9FA76BA08FC8@suse.de>
References: <alpine.DEB.2.00.1107242335580.18045@tiger>	<4E2CA6DE.4040900@web.de>	<CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com>	<20110725075305.GA32294@elte.hu>	<0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de>	<CAOJsxLHGgpNrHpfnHzD-aOJakE9q_4ym51_AYQHaj+waEZtSuw@mail.gmail.com>	<ED2ECD82-2B14-45FF-AA61-AB26B377B626@suse.de>	<CAOJsxLFDzSg55u92b6Qgvqn1yjaShYG_Bgdkzy19aBrzxo7FqA@mail.gmail.com>	<B0466610-8355-402E-B378-68BD3AF9CE2D@suse.de> <CAOJsxLFT-E5E3YFT5es8FkTfgu1xTvqf-k+WqgH47U+ZKxVVoQ@mail.gmail.com> <4E2D65D7.6030407@redhat.com>
To: Avi Kivity <avi@redhat.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 25.07.2011, at 14:47, Avi Kivity wrote:

> On 07/25/2011 03:45 PM, Pekka Enberg wrote:
>> On Mon, Jul 25, 2011 at 12:06 PM, Alexander Graf<agraf@suse.de>  wrote:
>> >>  And don't get this the wrong way either, I'm not hostile against other
>> >>  operating systems, but I simply am not interested enough in them to
>> >>  spend my time improving them.
>> >
>> >  Then kvm-tool is about as useful as Mac-on-Linux. Why don't we have MoL user land in the kernel? I even added support for KVM to it about a year ago. So all I need to do is change it to the kernel coding style, add some dependencies on kernel headers and I'm good for a pull request?
>> 
>> Oh, I dunno - have you tried that? If you're interested in sending a
>> patch against tools/kvm that adds KVM-based support to Mac, I'm happy
>> to review it and consider for inclusion. ;-)
> 
> The patch will be a lot bigger than tools/kvm itself.

And it will be full of ugly hacks and code that needs to be compiled on a Mac. I was actually trying to pick an example of a project that you really don't want to have in the kernel tree.

One point stays true however with MoL. I added support for KVM a year ago and haven't had to touch it since. It just works. Because we have a pretty stable kernel/user space interface. So the whole thing about having user space and kernel code live together in the same tree is moot there.

And if you need to share code with perf, then that just proves the point that perf doesn't belong inside the kernel tree either.


Alex

