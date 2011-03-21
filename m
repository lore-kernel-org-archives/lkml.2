Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465Ab1CUUl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 16:41:27 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59045 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394Ab1CUUlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 16:41:25 -0400
Date: Mon, 21 Mar 2011 16:41:19 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Po-Yu Chuang <ratbert.chuang@gmail.com>
cc: Ashwin Chaugule <ashbertslists@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Po-Yu Chuang <ratbert@faraday-tech.com>, tony@atomide.com,
        lkml <linux-kernel@vger.kernel.org>, joe@perches.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] arm: cmpxchg syscall should data abort if page not
 write
In-Reply-To: <AANLkTi=Zq0fiVf+GcRC8M+CPakwmEWn1rrqq_U4OehNy@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1103211639470.11889@xanadu.home>
References: <1300098516-1601-1-git-send-email-ratbert.chuang@gmail.com> <1300169637-1628-1-git-send-email-ratbert.chuang@gmail.com> <alpine.LFD.2.00.1103171301030.26889@xanadu.home> <AANLkTik1oEkLX3R-adK9-_2W+ku4j9YDikr+Z4vzfGtb@mail.gmail.com>
 <alpine.LFD.2.00.1103171344270.26889@xanadu.home> <AANLkTi=Zq0fiVf+GcRC8M+CPakwmEWn1rrqq_U4OehNy@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1230036926-1300740081=:11889"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1230036926-1300740081=:11889
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 18 Mar 2011, Po-Yu Chuang wrote:

> On Fri, Mar 18, 2011 at 1:57 AM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> > Nope.  The code being fixed here was suptly broken so it needs fixing.
> > However this code is almost never used, if at all, as it is a fall-back
> > solution for when all the better alternatives are not available for some
> > reasons (and I'm still wondering what those reasons are for Po-Yu Chuang
> > to actually use that code).  In practice this bug should have affected
> > no one.
> 
> We met this problem while porting an v5 SMP processor because kernel
> selects NEEDS_SYSCALL_FOR_CMPXCHG by default if CPU_32v5.
> 
> After we added our own implementation of __kuser_cmpxchg, this code
> is not needed anymore. But since this is actually a bug, it is still a good
> idea to submit a patch. :-)

Yes.  Please send to RMK's patch system with my ACK.


Nicolas
--8323328-1230036926-1300740081=:11889--
