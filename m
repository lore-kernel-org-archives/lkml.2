Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab0LVNsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 08:48:16 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43111 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845Ab0LVNsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 08:48:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=R7H2fNx1IrLbHo+y55yX6qEaAic8OwUCOULXM5/wMGies9yiTGzbB61ib9TvKqZMU8
         YH9v194N0o89rU6B6tS8Z3ixyFsl8MtgHJV9ONIkYrhWhhqpkDYWRLRoUbOMQ25rq63L
         X5kMFnSzn4Ij0RlH95Y9MpT2kp7FIcgWFKWYE=
Subject: Re: [PATCH v4] kptr_restrict for hiding kernel pointers
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
        jmorris@namei.org, tgraf@infradead.org, eugeneteo@kernel.org,
        kees.cook@canonical.com, davem@davemloft.net, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, eparis@parisplace.org,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1293023589.9820.186.camel@dan>
References: <1292708499.10804.89.camel@dan> <20101222130349.GB13412@elte.hu>
	 <1293023589.9820.186.camel@dan>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Dec 2010 14:48:08 +0100
Message-ID: <1293025688.3027.82.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 22 décembre 2010 à 08:13 -0500, Dan Rosenberg a écrit :
> > Hm, why is it off by default? Is there some user-space regression that is caused by 
> > this?
> > 
> > We really want good security measures to be active by default (and to work by 
> > default) - they are not worth much if they are not.
> > 
> 
> I agree entirely, but I've received a lot of resistance to these types
> of changes in net.  I'm afraid that if it's enabled by default, no one
> will actually allow use of the %pK specifier where it should be used.
> 

Actually, "net resistance" was against your first patches, using quick
and dirty techniques (Should I remind you some of them ?)

Now you have a helper, it should be easier to integrate the changes.

At least, if a mission critical legacy app want to see real pointers
values and a 2.6.38 kernel, it is a matter of sysadmin tweaks.



