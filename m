Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab0KKKDi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 05:03:38 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50011 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944Ab0KKKDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 05:03:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=YNlFs+99Hf+VSwK4lcecsWmJta/R1aCvESkxsqdf720SqVWGSr3AnZVyAlZHiwKzXp
         qLhQx3AiztwClHnMYnC4WL/0DkhzbePqTi3bS7GAz9Qnbq2GyaeCdSBq6nJp60gfe8qR
         tX7+8y2Rmf0jMOFTY7peJ+u1zWkZGVl3rWZ3E=
MIME-Version: 1.0
In-Reply-To: <AANLkTimXfstwyBzoXjY=iX+QBQSswy4_Rq5TjApqkYqJ@mail.gmail.com>
References: <AANLkTinwAL8dFsDbd-ZTQEcEziq6jZk82KPzNqMVxnOx@mail.gmail.com>
	<AANLkTim+BAYKWqiJzSQQLc4e_yNkMsNNnEp5u8YgC2Fk@mail.gmail.com>
	<AANLkTimXfstwyBzoXjY=iX+QBQSswy4_Rq5TjApqkYqJ@mail.gmail.com>
Date: Thu, 11 Nov 2010 18:03:35 +0800
Message-ID: <AANLkTin7SxDU0c6yWWfR8yF2dUmM7NE9EViPXA03a0Cs@mail.gmail.com>
Subject: Re: [Questions] How to run 'perf top' on ARM to profile kernel
 functions with modules loaded
From: Ming Lei <tom.leiming@gmail.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>2010/11/11 Ingo Molnar <mingo@elte.hu>:
> Must be some bug in the ELF symbol handling code - we've had many cases of quirks
> and special cases there. Please run 'perf archive' and send the resulting
> perf.data.tar.bz2 to Arnaldo in private mail. (the file will be big)

Sent to Arnaldo already.

2010/11/11 Kyungmin Park <kmpark@infradead.org>:
>
> I tried to build the perf as static and build success on ARM. But
> there's no display and no top results also.
> How do you build the perf on ARM? any hints or clues?

Cross-compiling perf tool is very painful, so I choose to compile
perf in Angstom on beagle-xm(ARM) directly, isn't it fun? :-)

thanks,
-- 
Lei Ming
