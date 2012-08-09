Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab2HIHa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 03:30:26 -0400
Received: from queue02.mail.zen.net.uk ([212.23.3.27]:50594 "EHLO
	queue02.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855Ab2HIHaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 03:30:25 -0400
X-Greylist: delayed 1777 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Aug 2012 03:30:25 EDT
Message-ID: <1344495577.2852.4.camel@computer2.home>
Subject: Re: [PATCH 01/22] ARM: add mechanism for late code patching
From: Tixy <tixy@yxit.co.uk>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Cyril Chemparathy <cyril@ti.com>, linux-arm-kernel@lists.infradead.org
Date: Thu, 09 Aug 2012 07:59:37 +0100
In-Reply-To: <alpine.LFD.2.02.1208081248340.5231@xanadu.home>
References: <1343775898-28345-1-git-send-email-cyril@ti.com>
	 <1343775898-28345-2-git-send-email-cyril@ti.com>
	 <alpine.LFD.2.02.1208040045360.5231@xanadu.home> <50219C45.7030601@ti.com>
	 <alpine.LFD.2.02.1208080106500.5231@xanadu.home> <5022673A.7060407@ti.com>
	 <alpine.LFD.2.02.1208080948210.5231@xanadu.home>
	 <20120808160517.GO18957@n2100.arm.linux.org.uk>
	 <alpine.LFD.2.02.1208081248340.5231@xanadu.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost02-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-08 at 12:56 -0400, Nicolas Pitre wrote:
> On Wed, 8 Aug 2012, Russell King - ARM Linux wrote:
> > Done correctly, it shouldn't be a problem, but I wouldn't say that
> > arch/arm/kernel/kprobes-test*.c is done correctly.  It's seen quite
> > a number of patching attempts since it was introduced for various
> > problems, and I've seen quite a number of builds fail for various
> > reasons in this file (none which I could be bothered to investigate.)
<snip>
> >
> As for build failures with that test code, I'd suggest you simply drop a 
> note to Tixy who is normally very responsive.

Indeed. If there are build failures, I'm happy to investigate and fix.

-- 
Tixy

