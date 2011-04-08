Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab1DHHHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 03:07:54 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:60180 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573Ab1DHHHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 03:07:53 -0400
X-Greylist: delayed 1408 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Apr 2011 03:07:53 EDT
Date: Fri, 8 Apr 2011 16:10:36 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: Pekka Enberg <penberg@kernel.org>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Ingo Molnar <mingo@elte.hu>,
        Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
        aarcange@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        joro@8bytes.org, penberg@cs.helsinki.fi, asias.hejun@gmail.com,
        gorcunov@gmail.com
Subject: Re: [ANNOUNCE] Native Linux KVM tool
Message-Id: <20110408161036.06288081.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <BANLkTi=XhcmpNkOa2QffBCuZOZfTZZaqvA@mail.gmail.com>
References: <1301592656.586.15.camel@jaguar>
	<4D982E89.8070502@redhat.com>
	<BANLkTinbCAUqaKfmKaj-7GXTh9F2if0x+Q@mail.gmail.com>
	<4D9847BC.9060906@redhat.com>
	<4D98716D.9040307@codemonkey.ws>
	<4D9873CD.3080207@redhat.com>
	<20110406093333.GB6465@elte.hu>
	<4D9E6F6E.9050709@codemonkey.ws>
	<BANLkTimEwAuL4PM9vBfogkrua-Z44AZQvg@mail.gmail.com>
	<20110408154712.8319bf74.yoshikawa.takuya@oss.ntt.co.jp>
	<BANLkTi=XhcmpNkOa2QffBCuZOZfTZZaqvA@mail.gmail.com>
X-Mailer: Sylpheed 3.1.0beta2 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I may get some interest in using this tool for my debugging/testing/
> > self-educational porpuses, but cannot know what I can do/expect.
> 
> Heh, it's all pretty straight-forward. Fetch the sources from this tree:
> 
>  git clone git://github.com/penberg/linux-kvm.git
> 
> Find something interesting to hack on and when you have something you
> want integrated send patches to penberg@kernel.org and CC this list.
> That's it!

Thank you for your answer!
Actually, I knew how to get the code because I am checking most of emails
on this ML.

What I wanted to know is what I can do with this tool in the future.

But OK, I got it that nothing is strictly determined at the moment about
what features can/should be integrated.

Takuya

> 
> In the long run, we hope to live in the main kernel tree under
> tools/kvm and be part of the regular kernel release cycle.
> 
>                        Pekka

