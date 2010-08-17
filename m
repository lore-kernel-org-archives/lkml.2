Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab0HQCR6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 22:17:58 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:39232 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab0HQCR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 22:17:57 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Aug 2010 22:17:57 EDT
X-Originating-Ip: 216.16.235.2
Date: Mon, 16 Aug 2010 22:12:52 -0400
From: Chris Frey <cdfrey@foursquare.net>
To: linux-kernel@vger.kernel.org
Subject: compiler warnings in 2.6.35.2
Message-ID: <20100817021252.GA17647@foursquare.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When compiling the latest 2.6.35.2 I get a ton of warnings like the
following.  Similar warnings were present in 2.6.35, and I assumed a
stable point release may have tackled them already.  But maybe they
are peculiar to my setup.  Warning below.

- Chris



  CC      mm/swap.o
In file included from include/linux/kobject.h:21,
                 from include/linux/sched.h:91,
                 from mm/swap.c:17:
include/linux/sysfs.h:183: warning: parameter has incomplete type
/home/cdfrey/kernel/git/linux/arch/x86/include/asm/cpufeature.h: In function `__static_cpu_has':
/home/cdfrey/kernel/git/linux/arch/x86/include/asm/cpufeature.h:315: warning: asm operand 1 probably doesn't match constraints


