Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab1CXX3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 19:29:38 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:59530 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab1CXX3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 19:29:34 -0400
Date: Thu, 24 Mar 2011 19:29:25 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] APM: delete APM in Linux-2.6.40
In-reply-to: <201103241315.34722.linux@rainbow-software.org>
Message-id: <alpine.LFD.2.02.1103241905250.16085@x980>
References: <alpine.LFD.2.02.1103232321070.3848@x980>
 <20110324154505.934a56a0.sfr@canb.auug.org.au>
 <alpine.LFD.2.02.1103240336590.4529@x980>
 <201103241315.34722.linux@rainbow-software.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Please don't turn Linux into second Windows.

No worry there.

I mention Microsoft not to advocate that Linux be Windows,
but to point out that this (hardware/firmware) ship sank 5 years
ago and Linux is still on the boat.  MS was able to delete 
APM support in 2006 from their source tree, yet we still carry it.

> If you don't want APM in the 
> kernel, just don't compile it. There are many people using older systems with 
> APM - and most of them wouldn't oppose to this removal as they don't even 
> know about it.

They can still run old Linux on an old APM-only laptop --
just like they can still run Windows 3.1 or Windows XP if they want to.

What we'd be taking away is their ability to run the latest
Linux kernel on that laptop.

The issue at hand is people (like me) who have to maintain
the latest Linux source code.  In sort, I don't want to
write, debug, and test a cpuidle driver for an apm-only laptop
when I could be spending effort on code that people will
actually run.

thanks,
-Len


