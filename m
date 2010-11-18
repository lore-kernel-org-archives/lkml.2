Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760727Ab0KRV60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 16:58:26 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37395 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757355Ab0KRV6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 16:58:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AlNWBnUfxHxt0NhxK4WKzqLcA/lGu+oDbUhaaCd54isFFD4nh39HBGk7TY483uneyB
         4Blf+wiXp46RoTbg+FAmjNkswgiYblHsX+cHmnLsH4+cu0AmIzPCkexz6YHXb5HQ9Yan
         24p8XiKWTp/5Vk/n0aIOGKesUr5jb0U9WP8EU=
Date: Fri, 19 Nov 2010 00:58:20 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [V2 PATCH 0/6] x86, NMI: give NMI handler a face-lift
Message-ID: <20101118215820.GM6028@lenovo>
References: <20101112161144.GP4823@redhat.com> <4CDD6CAD.30303@windriver.com> <20101112172755.GR4823@redhat.com> <20101116184325.GB4823@redhat.com> <4CE2E3C3.6060800@windriver.com> <20101118080516.GJ32621@elte.hu> <4CE52048.5080802@windriver.com> <1290086232.2109.1507.camel@laptop> <20101118193247.GF18100@redhat.com> <20101118215650.GL6028@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118215650.GL6028@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 12:56:50AM +0300, Cyrill Gorcunov wrote:
> On Thu, Nov 18, 2010 at 02:32:47PM -0500, Don Zickus wrote:
> ... 
> > On a side note I think I have a fix for the p4 problem but will probably
> > need Cyril to look at it.  Basically in, p4_pmu_clear_cccr_ovf() it is
> > using the high part of the cccr register to determine if the counter
> > overflowed, when it probably wants to use the low bits of the cccr
> > register and high bits of the event_base.
> >
> 
> Thanks a hige Don for pointing to the problem. Here is the patch.

s/hige/huge/ :)
