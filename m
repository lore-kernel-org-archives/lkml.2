Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab2GRCIG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 22:08:06 -0400
Received: from ozlabs.org ([203.10.76.45]:45209 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231Ab2GRCIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 22:08:00 -0400
Message-ID: <1342577283.25827.8.camel@concordia>
Subject: Re: [RFC/PATCH] Use kernel supplied MMU info for kvm tool
From: Michael Ellerman <michael@ellerman.id.au>
To: Pekka Enberg <penberg@kernel.org>
Cc: Matt Evans <matt@ozlabs.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
        prerna@linux.vnet.ibm.com, David Gibson <david@gibson.dropbear.id.au>,
        Sasha Levin <levinsasha928@gmail.com>,
        Asias He <asias.hejun@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Ingo Molnar <mingo@elte.hu>
Date: Wed, 18 Jul 2012 12:08:03 +1000
In-Reply-To: <CAOJsxLGf6K0G90i==-TJ8WmGvuwtp9mpxsCMSJYw7Wn-JAvpcA@mail.gmail.com>
References: <1342501220-10209-1-git-send-email-michael@ellerman.id.au>
	 <3e2231e9bf466549d1f9b12359f2f8f6@ozlabs.org>
	 <CAOJsxLGf6K0G90i==-TJ8WmGvuwtp9mpxsCMSJYw7Wn-JAvpcA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-17 at 17:09 +0300, Pekka Enberg wrote:
> On Tue, Jul 17, 2012 at 12:33 PM, Matt Evans <matt@ozlabs.org> wrote:
> > Just had a look, all good.  Thanks for tidying some old FIXMEs, especially
> > the page/segment DT props encoding grot -- and the designated inits in the
> > cpuinfo struct, whew, I heard the scream on IRC.  Sorry. ;-)
> >
> > Acked-by: Matt Evans <matt@ozlabs.org>
> 
> Applied, thanks guys!

Thanks Pekka.

It occurred to me overnight that I forgot to mention that in order to
build the new code you need the headers from a 3.5-rc1 era kernel (for
the ioctl & KVM_CAP definitions).

The easiest way to do that is to merge linus' tree into kvmtool.

Are you planning on doing that in the master kvmtool tree anytime soon?
It's still based on 3.4-rc1 it seems.

cheers


