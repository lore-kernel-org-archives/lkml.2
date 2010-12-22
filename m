Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab0LVNNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 08:13:13 -0500
Received: from mx1.vsecurity.com ([209.67.252.12]:50728 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab0LVNNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 08:13:12 -0500
Subject: Re: [PATCH v4] kptr_restrict for hiding kernel pointers
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, jmorris@namei.org,
        eric.dumazet@gmail.com, tgraf@infradead.org, eugeneteo@kernel.org,
        kees.cook@canonical.com, davem@davemloft.net, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, eparis@parisplace.org,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20101222130349.GB13412@elte.hu>
References: <1292708499.10804.89.camel@dan> <20101222130349.GB13412@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Dec 2010 08:13:09 -0500
Message-ID: <1293023589.9820.186.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hm, why is it off by default? Is there some user-space regression that is caused by 
> this?
> 
> We really want good security measures to be active by default (and to work by 
> default) - they are not worth much if they are not.
> 

I agree entirely, but I've received a lot of resistance to these types
of changes in net.  I'm afraid that if it's enabled by default, no one
will actually allow use of the %pK specifier where it should be used.

As far as I know, there's no actual breakage of anything in userspace,
but there's a general "it might make it harder to debug things in
certain limited circumstances" sentiment among some.  I never understood
why it is necessary for unprivileged users to be able to debug the
kernel.

Does anyone else have thoughts on this?

> Thanks,
> 
> 	Ingo


