Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab1GYKgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 06:36:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59457 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093Ab1GYKgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 06:36:13 -0400
Date: Mon, 25 Jul 2011 12:35:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexander Graf <agraf@suse.de>
Cc: Pekka Enberg <penberg@kernel.org>, Jan Kiszka <jan.kiszka@web.de>,
        torvalds@linux-foundation.org, avi@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gorcunov@gmail.com, levinsasha928@gmail.com,
        asias.hejun@gmail.com, prasadjoshi124@gmail.com
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
Message-ID: <20110725103517.GL28787@elte.hu>
References: <CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com>
 <20110725075305.GA32294@elte.hu>
 <0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de>
 <CAOJsxLHGgpNrHpfnHzD-aOJakE9q_4ym51_AYQHaj+waEZtSuw@mail.gmail.com>
 <ED2ECD82-2B14-45FF-AA61-AB26B377B626@suse.de>
 <CAOJsxLFDzSg55u92b6Qgvqn1yjaShYG_Bgdkzy19aBrzxo7FqA@mail.gmail.com>
 <20110725092656.GD28787@elte.hu>
 <68C2AB77-AA91-4B21-A321-2DB4EF8121C1@suse.de>
 <20110725101607.GI28787@elte.hu>
 <C79981BA-CFE9-48CD-839D-1ABD72DF266C@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C79981BA-CFE9-48CD-839D-1ABD72DF266C@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander Graf <agraf@suse.de> wrote:

> 
> On 25.07.2011, at 12:16, Ingo Molnar wrote:
> 
> >> 
> >>> So it was a no brainer for me to pull it into -tip.
> >> 
> >> The thing I don't agree with is that it should live in the 
> >> kernel tree.
> > 
> > FYI, tools/kvm/ *already* lives in the kernel tree - that is how 
> > it's developed and used and it also shares code with the kernel.
> 
> So you're just trying to make this a self-fulfilling prophecy now? 

No, i'm just trying to point out to you that it's already a fact that 
the tool already lives in a kernel tree and was developed there to 
the tune of 700+ commits within a few short months.

IMO you should not be arguing:

 'You should do X because that's my preference.'

IMO you should be arguing:

 'You should do X because technical advantage Y which is important to the project.'

We have listed numerous technical advantages of why we have chosen 
tools/kvm/ - and you have not countered that with any convincing 
technical disadvantage so far.

Thanks,

	Ingo
