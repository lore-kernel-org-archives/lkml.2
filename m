Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774Ab0DBKxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 06:53:47 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:33513 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752909Ab0DBKxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 06:53:41 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31 regression: programs crashing after a couple of days of uptime with hibernation
Date: Fri, 2 Apr 2010 12:53:28 +0200
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
References: <201004012332.49454.linux@rainbow-software.org> <201004020003.37305.linux@rainbow-software.org> <201004020033.55994.rjw@sisk.pl>
In-Reply-To: <201004020033.55994.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004021253.30668.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 April 2010 00:33:55 Rafael J. Wysocki wrote:
> On Friday 02 April 2010, Ondrej Zary wrote:
> > On Thursday 01 April 2010 23:45:33 you wrote:
> > > On Thursday 01 April 2010, Ondrej Zary wrote:
> > > > Hello,
> > > > with kernel 2.6.30, I can have uptime of more than a month on my
> > > > desktop PC (with hibernation). It's impossible with 2.6.31. After 1
> > > > to 3 days, processes that were running during hibernation (e.g.
> > > > konsole, kwin, kicker, xorg) start to crash randomly in very weird
> > > > ways. The kernel itself does not seem to crash. When I run the
> > > > crashed program again, it seems to work. Looks like some memory
> > > > corruption.
> > > >
> > > > This bug is also present in 2.6.32 and 2.6.33.
> > >
> > > Is the kernel 32-bit or 64-bit?  What kind of CPU is there in the box?
> >
> > It's old 32-bit i686 CPU - Cyrix MII.
>
> Please try with this patch applied:
> http://git.kernel.org/?p=linux/kernel/git/mingo/linux-2.6-x86.git;a=patch;h
>=8ae06d223f8203c72104e5c0c4ee49a000aedb42

Thanks, I'll try it. But I doubt that it will fix the problem. There were no 
changes in hibernate_asm_32.S between 2.6.30 and 2.6.31.

-- 
Ondrej Zary
