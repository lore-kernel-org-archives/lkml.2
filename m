Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307Ab1EMOG3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 10:06:29 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:58849 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756178Ab1EMOG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 10:06:27 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX185WIs19AQ5oJN3epqenUpPRw1mlfBXDMX1ENCD3I
	xqk07BgEXqT8JK
Subject: Re: Sched_autogroup and niced processes
From: Mike Galbraith <efault@gmx.de>
To: Carl-Johan Kjellander <carl-johan@klarna.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTimvehoQkiiX5EuPB0ozVKoPk3tAbg@mail.gmail.com>
References: <BANLkTimCpH3Nn2XnOJUKnK=dMObj1r8KEg@mail.gmail.com>
	 <BANLkTi=ckPK3BV07n=hmwOeqFUs3mrazFQ@mail.gmail.com>
	 <1305273950.15080.7.camel@marge.simson.net>
	 <20110513082250.GB13647@elte.hu> <1305276066.2561.1.camel@twins>
	 <20110513090537.GH13647@elte.hu> <1305277666.2561.9.camel@twins>
	 <20110513092933.GL13647@elte.hu> <1305279990.2466.4.camel@twins>
	 <20110513100411.GA21022@elte.hu>
	 <1305292406.27263.20.camel@marge.simson.net>
	 <BANLkTimvehoQkiiX5EuPB0ozVKoPk3tAbg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 16:06:23 +0200
Message-ID: <1305295583.27263.36.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-13 at 15:36 +0200, Carl-Johan Kjellander wrote:

> I can try the same thing at home on my Q6600 machine if I upgrade it,
> cause of course the Core i7 doesn't actually have 8 cores, they are
> just hyperthreaded. It might be a factor.
> 
> Or am doing something horribly wrong when I try to set the autogroup to 19?

You seemingly haven't niced the parent's group, else new clients would
behave themselves.

cat /proc/pid/NN/autogroup will show nice level for group of pid NN.

(Watch out you don't nice down something like kdeinit;)

	-Mike

