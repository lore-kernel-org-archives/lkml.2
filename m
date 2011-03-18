Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736Ab1CRVth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 17:49:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:37915 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932708Ab1CRVtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 17:49:19 -0400
Subject: Re: [git pull] Please pull powerpc.git next branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTinLb0sg1H6GDbZiddqGQ4a0=GRLYFJbL0G1Kv62@mail.gmail.com>
References: <1300427072.22236.1277.camel@pasglop>
	 <AANLkTinLb0sg1H6GDbZiddqGQ4a0=GRLYFJbL0G1Kv62@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 19 Mar 2011 08:48:54 +1100
Message-ID: <1300484934.22236.1285.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-18 at 06:34 -0700, Linus Torvalds wrote:
> > Here are the changes for this merge window for powerpc. One highlight
> > is irq data conversion so we can get rid of the legacy stuff. The new
> > Dynamic DMA windows for pSeries should also improve performances for
> > some devices nicely on more recent machines/firmwares. Plus a little
> > pack of embedded things.
> 
> Ok, I got a conflict with the of_platform_driver() removal which
> looked pretty trivial, but since I don't have a ppc cross-compile
> thing I couldn't even test-compile the end result. Please take a look
> to see that it went ok..

Ok, I'll have a look later today.

Thanks,
Ben.


