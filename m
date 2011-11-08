Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab1KHKlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 05:41:44 -0500
Received: from DMZ-MAILSEC-SCANNER-4.MIT.EDU ([18.9.25.15]:48929 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754881Ab1KHKlm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 05:41:42 -0500
X-AuditID: 1209190f-b7f6e6d0000008df-ee-4eb9076518e1
Subject: Re: [F.A.Q.] perf ABI backwards and forwards compatibility
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <20111108102235.GA1241@elte.hu>
Date: Tue, 8 Nov 2011 05:41:33 -0500
Cc: Theodore Tso <tytso@MIT.EDU>, Pekka Enberg <penberg@cs.helsinki.fi>,
        "Frank Ch. Eigler" <fche@redhat.com>, Vince Weaver <vince@deater.net>,
        Pekka Enberg <penberg@kernel.org>,
        Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?iso-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <F1D0EDA6-8D93-4FF8-BF3D-F8D02702E74F@mit.edu>
References: <20111106183132.GA4500@thunk.org> <CAOJsxLHvYo5zA+_m-AXuZHjAcGKE5q0ytmPCZ0Gye52LWq1p9Q@mail.gmail.com> <CAOJsxLG6kyq-RoQiBj0B_tThvOy1AxJf6XB2VfQFQJkwQ5cHcQ@mail.gmail.com> <20111106231953.GD4500@thunk.org> <alpine.LFD.2.02.1111070838520.1823@tux.localdomain> <alpine.DEB.2.02.1111071156230.28615@pianoman.cluster.toy> <20111107175942.GA9395@elte.hu> <y0mpqh3og3v.fsf@fche.csb> <alpine.LFD.2.02.1111072204370.3082@tux.localdomain> <20111107203514.GG24234@thunk.org> <20111108102235.GA1241@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
X-Mailer: Apple Mail (2.1251.1)
X-Brightmail-Tracker: H4sIAAAAAAAAA02SS0wTQRzGM7vtdqmsLuU1VoG4GhSwiMphNMagRLMnwsWLJupKF1psS90t
	BPAACgFBBTWaaAWVRFFBgjwkVE2xxRTEC0hBRR6+MFoVI1ASoiF224Dcvpnv+37zn8yQuMoj
	V5N6k4UXTJyBIZQyVVD4eg2vsKUlld2MQQNlAwRynH1NoF73AkA1H77IUfvoDIFGxmk0OI+h
	misn0ODjGgK1vyqRo/f3+wlUNrMgRz3nO2XoY9VPBfrxqYtADQ8rQQrNuidJ9srAc8A2DSO2
	tDeOHSn7i7M265iCbW2oINjeq39k7OfhNoz9ZR8i2LaXJ9mZ1uj04IPKXVreoM/jhS27jyp1
	3bUOzOwNyx//2oQVAxddCYJISCfDRmuLLKAjYP94MyFpFW0HsOXenkqg9OlmAJ+MnpMFFn0Y
	nPNWK6RUKJ0Kq9/W+tsUvR0+GJnya5yOh28WvmGSJmgGjk53+feD6M3wm21MLmkZvQG+qHMQ
	EhSnSwjovejBAuUEWF/3HQ9Ad8KSu2fkgZP/4nDiXrm/HUbHwKeuWXlg7hhY6h0lLoAQ67JB
	rMsGsS7j3gJ4A4jSGgs1Rk5vEPkMjZjBmUy8oElONOotibw2txX4n3T1qk4w52CcgCYBE0xd
	C+9MU8m5PLHA6ASrSYwJpxSELU218liOtkDHibojQq6BF50AkjgTRjGnfXFKyxUU8kLOorWG
	lDGR1KnOlDQVncVZ+OM8b+aFRXctSTKQapWgIQKfxedn6g2W/zZGBknwYB/cLmUo0cwZRX1W
	wO8D69SR1E3JoCVDl2ta6i5+UQ+I9F0llBKkVLDvAy+1PT4w5gOXazoksIX7b6mLgWnX/sR3
	2YVK9+07jRqbW9N9Y/Kwus65avhydH5PxY4oc37z1S7FEJmVfRhW2h9lNE2bt10fRo1mQ1Lu
	+KRr/uxU0UZ3aWzBMy90DO0bLK63p3eosYht87OHnFMdRcnZl9JvlR/YlDmRGhnr6nCt8LzJ
	HFxInKj6/bYirubM3gRGJuq4rfG4IHL/AHZjFKt9AwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 8, 2011, at 5:22 AM, Ingo Molnar wrote:

> We do even more than that, the perf ABI is fully backwards *and* 
> forwards compatible: you can run older perf on newer ABIs and newer 
> perf on older ABIs.

It's great to hear that!   But in that case, there's an experiment we can't really run, which is if perf had been developed in a separate tree, would it have been just as successful?

My belief is that perf was successful because *you* and the other perf developers were competent developers, and who got things right.   Not because it was inside the kernel tree.   You've argued that things were much better because it was inside the tree, but that's not actually something we can put to a scientific repeatable experiment.

I will observe that some of the things that caused me to be come enraged by system tap (such as the fact that I simply couldn't even build the damned thing on a non-Red Hat compilation environment, would not have been solved by moving Systemtap into the kernel git tree --- at least not without moving a large number of its external dependencies into the kernel tree as well, such as the elf library, et. al.)   So there is a whole class of problems that were seen in previous tooling systems that were not caused by the fact that they were separate from the kernel, but that they weren't being developed by the kernel developers, so they didn't understand how to make the tool work well for kernel developers.

If we had gone back in time, and had the same set of perf developers working in an external tree, and Systemtap and/or Oprofile had been developed in the kernel tree, would it really have made that much difference?   Sure, Linus and other kernel developers would have yelled at the Systemtap and Oprofile folks more, but I haven't seen that much evidence that they listened to us when they were outside of the kernel tree, and it's not obvious they would have listened with the code being inside the kernel tree.

My claim is that is that outcome wouldn't have been all that different, and that's because the difference was *you*, Ingo Molnar, as a good engineer, would have designed a good backwards compatible ABI whether the code was inside or outside of the kernel, and you would have insisted on good taste and usefulness to kernel programmers whether perf was in our out of the kernel, and you would have insisted on kernel coding guidelines and regular release cycles, even if perf was outside of the kernel.   As Linus sometimes like to say, in many cases it's more about the _people_.

Regards,

-- Ted


