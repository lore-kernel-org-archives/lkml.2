Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903Ab1KHKWF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 05:22:05 -0500
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:63697 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751475Ab1KHKWB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 05:22:01 -0500
X-AuditID: 1209190c-b7f806d0000008d6-a3-4eb902c76631
Subject: Re: [F.A.Q.] the advantages of a shared tool/kernel Git repository, tools/perf/ and tools/kvm/
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=windows-1252
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <20111108093225.GB32533@elte.hu>
Date: Tue, 8 Nov 2011 05:21:50 -0500
Cc: Theodore Tso <tytso@MIT.EDU>, Anthony Liguori <anthony@codemonkey.ws>,
        Pekka Enberg <penberg@kernel.org>, Vince Weaver <vince@deater.net>,
        Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?iso-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <EDBAFB6F-4E3B-42B0-93E6-DF162B9859A6@mit.edu>
References: <CAOJsxLHvYo5zA+_m-AXuZHjAcGKE5q0ytmPCZ0Gye52LWq1p9Q@mail.gmail.com> <CAOJsxLG6kyq-RoQiBj0B_tThvOy1AxJf6XB2VfQFQJkwQ5cHcQ@mail.gmail.com> <20111106231953.GD4500@thunk.org> <alpine.LFD.2.02.1111070838520.1823@tux.localdomain> <alpine.DEB.2.02.1111071156230.28615@pianoman.cluster.toy> <CAOJsxLEfapPPU8cEfeCMq9_oG6858YzFS_fkWQEo_fxs+xde9A@mail.gmail.com> <20111107203255.GF24234@thunk.org> <CAOJsxLEKx5M5L_N42pQpo2hcNhseQKhUo6CXAyQHesJRWFASKQ@mail.gmail.com> <4EB85969.2010108@codemonkey.ws> <12F471C8-2CF3-4CD7-B417-C8CC898669E6@mit.edu> <20111108093225.GB32533@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
X-Mailer: Apple Mail (2.1251.1)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOKsWRmVeSWpSXmKPExsUixG6nonucaaefwam9JhYX2y6yWRzsvs5m
	ceLKP0aLOQ+fsVpsufOZzeLWPQGLOVMLLS7vmsNmseVSM6tF2+d/rBbHe3ewWGzeNJXZ4lHf
	W3aLN4/3s1ms2tDF6MDvceUph8fUi0cYPVpOaHrcavvD7LFz1l12j02rOtk83p07x+5xYsZv
	Fo8n1zYzebzfd5XNY/Ppao/Pm+QCeKK4bFJSczLLUov07RK4MuadqCro1Kp4dmY9SwPjf4Uu
	Rk4OCQETiUWrl7FC2GISF+6tZ+ti5OIQEtjHKNE8eS0zhLOeUaKp/yArhHOKSeJ47xJGkBZh
	gXSJb0vOgNm8AsYSa269YwGxmQX0JHZc/wU2lk1ASeLOp/1gcU4BXYlp+xayg9gsAioSd1pn
	sYAMZRa4wyoxddorRohmbYllC18zQwy1knj5oYkFYvNRFok36y6BTRIRkJfYc+wL1OHyEi1f
	77BNYBScheSQWUgOmYVk7gJG5lWMsim5Vbq5iZk5xanJusXJiXl5qUW6hnq5mSV6qSmlmxhB
	8ckpybOD8c1BpUOMAhyMSjy8M0V3+AmxJpYVV+YeYpTkYFIS5ZVh3OknxJeUn1KZkVicEV9U
	mpNafIhRgoNZSYRXqQmonDclsbIqtSgfJiXNwaIkzntwh4OfkEB6YklqdmpqQWoRTFaGg0NJ
	grcOmIaEBItS01Mr0jJzShDSTBycIMN5gIbXg9TwFhck5hZnpkPkTzEqSonz5oIkBEASGaV5
	cL2w9PmKURzoFWFeC5AqHmDqhet+BTSYCWhwu+42kMEliQgpqQbGZr5XV18XF//kZzTcJuxs
	k3Hpzbw5Bpf5NpzX1lPzD1sUftXlabGCzd7XPbdY1bluc3zKXsjrWXA3cmN2iWaKlOqdMoHz
	W15/t+DP69T5n2exOlZuaw3zpD0Lm7y0J0QvlS3ZdyZLTb3ZsNvZPFxvXffzpslZhSvz10Ww
	Hr65Otjh7LvMC1eVWIozEg21mIuKEwHqOGI6egMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 8, 2011, at 4:32 AM, Ingo Molnar wrote:
> 
> No ifs and when about it, these are the plain facts:
> 
> - Better features, better ABIs: perf maintainers can enforce clean, 
>   functional and usable tooling support *before* committing to an 
>   ABI on the kernel side.

"We don't have to be careful about breaking interface compatibility while we are developing new features".

The flip side of this is that it's not obvious when an interface is stable, and when it is still subject to change.  It makes life much harder for any userspace code that doesn't live in the kernel.   And I think we do agree that moving all of userspace into a single git tree makes no sense, right?

> - We have a shared Git tree with unified, visible version control. I
>   can see kernel feature commits followed by tooling support, in a
>   single flow of related commits:
> 
>      perf probe: Update perf-probe document
>      perf probe: Support --del option
>      trace-kprobe: Support delete probe syntax
> 
>   With two separate Git repositories this kind of connection between
>   the tool and the kernel is inevitably weakened or lost.

"We don't have to clearly document new interfaces between kernel and userspace, and instead rely on git commit order for people to figure out what's going on with some new interface"

> - Easier development, easier testing: if you work on a kernel 
>   feature and on matching tooling support then it's *much* easier to
>   work in a single tree than working in two or more trees in 
>   parallel. I have worked on multi-tree features before, and except
>   special exceptions they are generally a big pain to develop.

I've developed in the split tree systems, and it's really not that hard.  It does mean you have to be explicit about designing interfaces up front, and then you have to have a good, robust way of negotiating what features are in the kernel, and what features are supposed by the userspace --- but if you don't do that then having good backwards and forwards compatibility between different versions of the tool simply doesn't exist.

So at the end of the day it question is whether you want to be able to (for example) update e2fsck to get better ability to fix more file system corruptions, without needing to upgrade the kernel.   If you want to be able to use a newer, better e2fsck with an older, enterprise kernel, then you have use certain programming disciplines.   That's where the work is, not in whether you have to maintain two git trees or a single git tree.

> - We are using and enforcing established quality control and coding
>   principles of the kernel project. If we mess up then Linus pushes
>   back on us at the last line of defense - and has pushed back on us
>   in the past. I think many of the currently external kernel
>   utilities could benefit from the resulting rise in quality.
>   I've seen separate tool projects degrade into barely usable
>   tinkerware - that i think cannot happen to perf, regardless of who
>   maintains it in the future.

That's basically saying that if you don't have someone competent managing the git tree and providing quality assurance, life gets hard.   Sure.   But at the same time, does it scale to move all of userspace under one git tree and depending on Linus to push back? 

I mean, it would have been nice to move all of GNOME 3 under the Linux kernel, so Linus could have pushed back on behalf of all of us power users, but as much as many of us would have appreciated someone being able to push back against the insanity which is the GNOME design process, is that really a good enough excuse to move all of GNOME 3 into the kernel source tree?   :-)

> - Better debuggability: sometimes a combination of a perf
>   change in combination with a kernel change causes a breakage. I
>   have bisected the shared tree a couple of times already, instead
>   of having to bisect a (100,000 commits x 10,000 commits) combined
>   space which much harder to debug …

What you are describing happens when someone hasn't been careful about their kernel/userspace interfaces.

If you have been rigorous with your interfaces, this isn't really an issue.   When's the last time we've had to do a NxM exhaustive testing to find a broken sys call ABI between (for example) the kernel and MySQL?

> - Code reuse: we can and do share source code between the kernel and
>   the tool where it makes sense. Both the tooling and the kernel
>   side code improves from this. (Often explicit librarization makes
>   little sense due to the additional maintenance overhead of a split
>   library project and the impossibly long latency of how the kernel
>   can rely on the ready existence of such a newly created library
>   project.)

How much significant code really can get shared?   Memory allocation is different between kernel and userspace code, how you do I/O is different, error reporting conventions are generally different, etc.   You might have some serialization and deserialization code which is in common, but (surprise!) that's generally part of your interface, which is hopefully relatively stable especially once the tool and the interface has matured.

-- Ted


