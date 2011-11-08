Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab1KHLVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 06:21:06 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57278 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab1KHLVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 06:21:03 -0500
Date: Tue, 8 Nov 2011 13:20:46 +0200 (EET)
From: Pekka Enberg <penberg@cs.helsinki.fi>
X-X-Sender: penberg@tux.localdomain
To: Theodore Tso <tytso@MIT.EDU>
cc: Ingo Molnar <mingo@elte.hu>, "Frank Ch. Eigler" <fche@redhat.com>,
        Vince Weaver <vince@deater.net>, Pekka Enberg <penberg@kernel.org>,
        Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [F.A.Q.] perf ABI backwards and forwards compatibility
In-Reply-To: <F1D0EDA6-8D93-4FF8-BF3D-F8D02702E74F@mit.edu>
Message-ID: <alpine.LFD.2.02.1111081317160.18135@tux.localdomain>
References: <20111106183132.GA4500@thunk.org> <CAOJsxLHvYo5zA+_m-AXuZHjAcGKE5q0ytmPCZ0Gye52LWq1p9Q@mail.gmail.com> <CAOJsxLG6kyq-RoQiBj0B_tThvOy1AxJf6XB2VfQFQJkwQ5cHcQ@mail.gmail.com> <20111106231953.GD4500@thunk.org> <alpine.LFD.2.02.1111070838520.1823@tux.localdomain>
 <alpine.DEB.2.02.1111071156230.28615@pianoman.cluster.toy> <20111107175942.GA9395@elte.hu> <y0mpqh3og3v.fsf@fche.csb> <alpine.LFD.2.02.1111072204370.3082@tux.localdomain> <20111107203514.GG24234@thunk.org> <20111108102235.GA1241@elte.hu>
 <F1D0EDA6-8D93-4FF8-BF3D-F8D02702E74F@mit.edu>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Nov 2011, Theodore Tso wrote:
> It's great to hear that!   But in that case, there's an experiment we 
> can't really run, which is if perf had been developed in a separate 
> tree, would it have been just as successful?

Experiment, eh?

We have the staging tree because it's a widely acknowledged belief that 
kernel code in the tree tends to improve over time compared to code that's 
sitting out of the tree. Are you disputing that belief?

If you don't dispute that, what makes you think the same effect 
doesn't apply to code that looks like Linux code and is developed the same 
way but runs in userspace?

 			Pekka
