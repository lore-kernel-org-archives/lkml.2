Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab2JPSyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 14:54:46 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:43762 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755681Ab2JPSyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 14:54:45 -0400
Date: Tue, 16 Oct 2012 18:54:44 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Ezequiel Garcia <elezegarcia@gmail.com>
cc: Tim Bird <tim.bird@am.sony.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "celinux-dev@lists.celinuxforum.org" 
	<celinux-dev@lists.celinuxforum.org>
Subject: Re: [Q] Default SLAB allocator
In-Reply-To: <CALF0-+XLXAh3=OScQ=V0F80ZcnTGjHox68SApOwPUYVvmjdqPw@mail.gmail.com>
Message-ID: <0000013a6aed8d12-71a82caf-366a-425c-a963-79077f62d673-000000@email.amazonses.com>
References: <CALF0-+XGn5=QSE0bpa4RTag9CAJ63MKz1kvaYbpw34qUhViaZA@mail.gmail.com> <m27gqwtyu9.fsf@firstfloor.org> <alpine.DEB.2.00.1210111558290.6409@chino.kir.corp.google.com> <m2391ktxjj.fsf@firstfloor.org> <CALF0-+WLZWtwYY4taYW9D7j-abCJeY90JzcTQ2hGK64ftWsdxw@mail.gmail.com>
 <alpine.DEB.2.00.1210130252030.7462@chino.kir.corp.google.com> <CALF0-+Xp_P_NjZpifzDSWxz=aBzy_fwaTB3poGLEJA8yBPQb_Q@mail.gmail.com> <alpine.DEB.2.00.1210151745400.31712@chino.kir.corp.google.com> <CALF0-+WgfnNOOZwj+WLB397cgGX7YhNuoPXAK5E0DZ5v_BxxEA@mail.gmail.com>
 <1350392160.3954.986.camel@edumazet-glaptop> <507DA245.9050709@am.sony.com> <CALF0-+XLXAh3=OScQ=V0F80ZcnTGjHox68SApOwPUYVvmjdqPw@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2012, Ezequiel Garcia wrote:

> It might be worth reminding that very small systems can use SLOB
> allocator, which does not suffer from this kind of fragmentation.

Well, I have never seen non experimental systems that use SLOB. Others
have claimed they exist.


