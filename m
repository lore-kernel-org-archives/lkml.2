Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933468Ab2JKCqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:46:39 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:51807 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933061Ab2JKCqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:46:38 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/vkJJSWw/vRKKCMTGesxhLoeGf4JXkq9ikZI4QJw
	pQKa+xJuYJUUM6
Message-ID: <1349923594.6989.19.camel@marge.simpson.net>
Subject: Re: Scheduler queues for less os-jitter?
From: Mike Galbraith <efault@gmx.de>
To: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 11 Oct 2012 04:46:34 +0200
In-Reply-To: <op.wly58nr56426ze@localhost.localdomain>
References: <op.wly58nr56426ze@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-10 at 20:13 +0200, Uwaysi Bin Kareem wrote: 
> I was just wondering, have you considered this?
> 
> If daemons are contributing to os-jitter, wouldn`t having them all on  
> their own queue reduce jitter? So people could have the stuff like in  
> Ubuntu they want, without affecting jitter, or needing stuff like Tiny  
> Core, for tiny jitter?
> 
> So you get (simplified) something like mainapp - process1 in queue 2,  
> mainapp - process2 in queue 2, mainapp - process 3 in queue 2, etc.
> 
> Or is that already batch maybe, lol.

You could try SCHED_AUTOGROUP, or create whatever task groups manually,
or use systemd to do that for you.  Like everything else having anything
to do with scheduling, all are double edged swords, so may help, may
hurt.

-Mike

