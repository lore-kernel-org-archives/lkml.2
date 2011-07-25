Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab1GYKWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 06:22:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38857 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317Ab1GYKV6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 06:21:58 -0400
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <20110725101607.GI28787@elte.hu>
Date: Mon, 25 Jul 2011 12:21:56 +0200
Cc: Pekka Enberg <penberg@kernel.org>, Jan Kiszka <jan.kiszka@web.de>,
        torvalds@linux-foundation.org, avi@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gorcunov@gmail.com, levinsasha928@gmail.com,
        asias.hejun@gmail.com, prasadjoshi124@gmail.com
Content-Transfer-Encoding: 8BIT
Message-Id: <C79981BA-CFE9-48CD-839D-1ABD72DF266C@suse.de>
References: <alpine.DEB.2.00.1107242335580.18045@tiger> <4E2CA6DE.4040900@web.de> <CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com> <20110725075305.GA32294@elte.hu> <0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de> <CAOJsxLHGgpNrHpfnHzD-aOJakE9q_4ym51_AYQHaj+waEZtSuw@mail.gmail.com> <ED2ECD82-2B14-45FF-AA61-AB26B377B626@suse.de> <CAOJsxLFDzSg55u92b6Qgvqn1yjaShYG_Bgdkzy19aBrzxo7FqA@mail.gmail.com> <20110725092656.GD28787@elte.hu> <68C2AB77-AA91-4B21-A321-2DB4EF8121C1@suse.de> <20110725101607.GI28787@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 25.07.2011, at 12:16, Ingo Molnar wrote:

>> 
>>> So it was a no brainer for me to pull it into -tip.
>> 
>> The thing I don't agree with is that it should live in the kernel 
>> tree.
> 
> FYI, tools/kvm/ *already* lives in the kernel tree - that is how it's 
> developed and used and it also shares code with the kernel.

So you're just trying to make this a self-fulfilling prophecy now? I already stated before that I could easily add those 'requirements' to any project I liked. That still wouldn't mean it's a good idea to clutter the _kernel_ repository with its code. It's not a kernel.


Alex

