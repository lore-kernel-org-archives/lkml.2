Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932769Ab1EMJHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 05:07:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:41281 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201Ab1EMJHw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 05:07:52 -0400
Subject: Re: Sched_autogroup and niced processes
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, Yong Zhang <yong.zhang0@gmail.com>,
        Carl-Johan Kjellander <carl-johan@klarna.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110513090537.GH13647@elte.hu>
References: <BANLkTimCpH3Nn2XnOJUKnK=dMObj1r8KEg@mail.gmail.com>
	 <BANLkTi=ckPK3BV07n=hmwOeqFUs3mrazFQ@mail.gmail.com>
	 <1305273950.15080.7.camel@marge.simson.net>
	 <20110513082250.GB13647@elte.hu> <1305276066.2561.1.camel@twins>
	 <20110513090537.GH13647@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 13 May 2011 11:07:46 +0200
Message-ID: <1305277666.2561.9.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-13 at 11:05 +0200, Ingo Molnar wrote:
> Could we somehow automate this:
> 
>   > echo 19 > /proc/'pid of seti@home'/autogroup
> 
> and split off nice 19 tasks into separate groups and lower the group's 
> priority? 

Well I guess you can stack on all kinds of heuristics, do we want to?
I'd argue for not, keep is simple.
