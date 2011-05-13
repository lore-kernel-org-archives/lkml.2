Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933024Ab1EMNYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 09:24:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:43406 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab1EMNYi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 09:24:38 -0400
Subject: Re: Sched_autogroup and niced processes
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Yong Zhang <yong.zhang0@gmail.com>,
        Carl-Johan Kjellander <carl-johan@klarna.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1305292406.27263.20.camel@marge.simson.net>
References: <BANLkTimCpH3Nn2XnOJUKnK=dMObj1r8KEg@mail.gmail.com>
	 <BANLkTi=ckPK3BV07n=hmwOeqFUs3mrazFQ@mail.gmail.com>
	 <1305273950.15080.7.camel@marge.simson.net>
	 <20110513082250.GB13647@elte.hu> <1305276066.2561.1.camel@twins>
	 <20110513090537.GH13647@elte.hu> <1305277666.2561.9.camel@twins>
	 <20110513092933.GL13647@elte.hu> <1305279990.2466.4.camel@twins>
	 <20110513100411.GA21022@elte.hu>
	 <1305292406.27263.20.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 13 May 2011 15:24:30 +0200
Message-ID: <1305293070.2466.32.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-13 at 15:13 +0200, Mike Galbraith wrote:
> 
> > Still, the other important problem is that we still seem to have a bug, even 
> > with the cgroup set to low prio seti@home is sucking up CPU resources ...
> 
> I don't see how.  

Agreed, with two groups, a spinner each, and then setting the group
weight low yields things like:

 1927 root      20   0  105m  672  192 R 98.1  0.0   0:20.50 bash  
 1933 root      20   0  105m  656  180 R  2.0  0.0   0:07.29 bash  

So all just seems to work as advertised.
