Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934373Ab1IOSMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 14:12:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47930 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934271Ab1IOSMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 14:12:43 -0400
Date: Thu, 15 Sep 2011 20:12:42 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Meyer <thomas@m3y3r.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sys_poll(): fix function definition/negative timeout values
Message-ID: <20110915181242.GZ7761@one.firstfloor.org>
References: <1316090761.6545.70.camel@localhost.localdomain> <m27h59g0k7.fsf@firstfloor.org> <1316109917.2492.3.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1316109917.2492.3.camel@edumazet-laptop>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 08:05:17PM +0200, Eric Dumazet wrote:
> Le jeudi 15 septembre 2011 à 10:47 -0700, Andi Kleen a écrit :
> > Thomas Meyer <thomas@m3y3r.de> writes:
> > 
> > > Fix negative timeout values for x86 userland on x86_64 kernels.
> > > Align sys_poll() definition to glibc's definition.
> > 
> > Nack. Please write a compat wrapper that sign extends.
> > 
> 
> Why ?

Because we shouldn't change existing interfaces and there could
be valid reasons on 64bit for really long delays.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
