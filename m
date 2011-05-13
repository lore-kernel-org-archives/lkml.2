Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129Ab1EMIlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 04:41:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:47879 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758093Ab1EMIlO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 04:41:14 -0400
Subject: Re: Sched_autogroup and niced processes
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, Yong Zhang <yong.zhang0@gmail.com>,
        Carl-Johan Kjellander <carl-johan@klarna.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110513082250.GB13647@elte.hu>
References: <BANLkTimCpH3Nn2XnOJUKnK=dMObj1r8KEg@mail.gmail.com>
	 <BANLkTi=ckPK3BV07n=hmwOeqFUs3mrazFQ@mail.gmail.com>
	 <1305273950.15080.7.camel@marge.simson.net>
	 <20110513082250.GB13647@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 13 May 2011 10:41:06 +0200
Message-ID: <1305276066.2561.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-13 at 10:22 +0200, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > > > time make -j12 # with seti@home running
> > > > real    4m16.753s
> > > > user    10m33.770s
> > > > sys     1m39.710s
> > > >
> > > > time make -j12 # without seti@home running
> > > > real    2m12.480s
> > > > user    10m11.580s
> > > > sys     1m39.980s
> 
> I think the practical question here is to make seti@home run more idle.
> 
> Are there some magic cgroup commands you could recommend for that?

Yong already did.
