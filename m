Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584Ab1GYNaC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 09:30:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50155 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178Ab1GYN37 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 09:29:59 -0400
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <1311599366.14203.42.camel@jaguar>
Date: Mon, 25 Jul 2011 15:29:56 +0200
Cc: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Jan Kiszka <jan.kiszka@web.de>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gorcunov@gmail.com, levinsasha928@gmail.com,
        asias.hejun@gmail.com, prasadjoshi124@gmail.com
Content-Transfer-Encoding: 8BIT
Message-Id: <83392120-2809-429C-A75F-9A23E25B1A56@suse.de>
References: <alpine.DEB.2.00.1107242335580.18045@tiger> <4E2CA6DE.4040900@web.de> <CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com> <20110725075305.GA32294@elte.hu> <0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de> <CAOJsxLHGgpNrHpfnHzD-aOJakE9q_4ym51_AYQHaj+waEZtSuw@mail.gmail.com> <ED2ECD82-2B14-45FF-AA61-AB26B377B626@suse.de> <CAOJsxLFDzSg55u92b6Qgvqn1yjaShYG_Bgdkzy19aBrzxo7FqA@mail.gmail.com> <B0466610-8355-402E-B378-68BD3AF9CE2D@suse.de> <CAOJsxLFT-E5E3YFT5es8FkTfgu1xTvqf-k+WqgH47U+ZKxVVoQ@mail.gmail.com> <4E2D65D7.6030407@redhat.com> <0747BB86-5A2E-449D-BF03-9FA76BA08FC8@suse.de> <1311599366.14203.42.camel@jaguar>
To: Pekka Enberg <penberg@kernel.org>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 25.07.2011, at 15:09, Pekka Enberg wrote:

> Hi Alexander,
> 
> On Mon, 2011-07-25 at 14:51 +0200, Alexander Graf wrote:
>> And if you need to share code with perf, then that just proves the
>> point that perf doesn't belong inside the kernel tree either.
> 
> You seem to want to prove something here but our reasoning is based on
> experience and practicalities - not some theoretical idea what should
> and what shouldn't be in the Linux kernel tree. I really don't think
> that perf would have turned out to be as useful as it is if it was
> developed out-of-the-tree.

IIUC that was mainly because the interface is very very closely coupled with kernel code.

> That's also why we think tools/kvm is such a good idea.

I like pears, so I like apples too?


Alex

