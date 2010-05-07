Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab0EGIJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 04:09:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325Ab0EGIJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 04:09:44 -0400
Date: Fri, 7 May 2010 10:08:12 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       ysato@users.sourceforge.jp, tony.luck@intel.com, dhowells@redhat.com,
       kyle@mcmartin.ca, benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       jgarzik@pobox.com, hare@suse.de, felipe.balbi@nokia.com
Subject: Re: [PATCH] removing redundant ifdefs
Message-ID: <20100507080812.GB1880@jolsa.lab.eng.brq.redhat.com>
References: <1273167377-14270-1-git-send-email-jolsa@redhat.com>
 <20100506180114.GB15797@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100506180114.GB15797@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06, 2010 at 07:01:14PM +0100, Russell King - ARM Linux wrote:
> On Thu, May 06, 2010 at 07:36:04PM +0200, Jiri Olsa wrote:
> >  arch/arm/include/asm/processor.h              |    2 --
> >  arch/arm/mach-ixp23xx/include/mach/platform.h |    3 ---
> >  arch/arm/plat-omap/include/plat/clock.h       |    5 -----
> 
> I've not received any patches relating to the above, but I seem to
> have received everything else, including stuff for PPC and x86.
> 
> Maybe you've negated the list of people to send patches to?

thats strange, I also did not received copy of this part,
and I got everything else..

but I checked the lkml and it's there:
http://lkml.org/lkml/2010/5/6/255

not sure whats wrong..

wbr,
jirka
