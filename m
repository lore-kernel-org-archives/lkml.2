Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab0DITrY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 15:47:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44665 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754283Ab0DITrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 15:47:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Dillow <dave@thedillows.org>
Subject: Re: [Bug #15454] r8169 exits with error -22 since 2.6.33
Date: Fri, 9 Apr 2010 21:50:42 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Conrad Kostecki <ConiKost@gmx.de>, romieu@fr.zoreil.com
References: <cjwJ7Pf9h0L.A.9pB.1DmvLB@chimera> <onZ81XwyNTD.A.PlC.tEmvLB@chimera> <1270775683.26861.4.camel@obelisk.thedillows.org>
In-Reply-To: <1270775683.26861.4.camel@obelisk.thedillows.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201004092150.42603.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 April 2010, David Dillow wrote:
> On Fri, 2010-04-09 at 01:04 +0200, Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15454
> > Subject		: r8169 exits with error -22 since 2.6.33
> > Submitter	: Conrad Kostecki <ConiKost@gmx.de>
> > Date		: 2010-03-05 22:32 (35 days old)
> 
> Francois attached a patch to the bugzilla entry that ignores the failure
> to enable MWI on the device. That may get the NIC up and running, but
> that area of the driver doesn't seem to have changed since 2.6.32, so
> perhaps this is just a canary -- I'm betting that the cache line size is
> not getting set properly, and it probably affects more than just this
> NIC.

Thanks for the update.

Rafael
