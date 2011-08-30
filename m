Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab1H3SpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 14:45:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49285 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755862Ab1H3SpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 14:45:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [Bug #41102] BUG dentry: Poison overwritten / BUG buffer_head: Poison overwritten
Date: Tue, 30 Aug 2011 20:47:03 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <Sm7qbRR0zn.A.yAG.LepWOB@chimera> <gUVi6eNP8RE.A.yOG.depWOB@chimera> <1314706380.1989.8.camel@x61.thuisdomein>
In-Reply-To: <1314706380.1989.8.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108302047.03193.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 30, 2011, Paul Bolle wrote:
> On Sun, 2011-08-28 at 21:01 +0200, Rafael J. Wysocki wrote:
> > Please verify if it still should
> > be listed and let the tracking team know (either way).
> 
> From comment #2:
> > [...] please note that the 3.0.1 kernel I
> > triggered this issue with seems to be the first I ran on this machine that has
> > CONFIG_SLUB_DEBUG_ON set. So on this machine this issue - if it's more than a
> > one time goof - would never have showed up in the logs unless I manually booted
> > with "slub_debug" on the command line. And I can't remember booting with
> > "slub_debug".
> 
> At this moment I see little reason to track this bug entry as a
> regression.

OK, dropped from the list of recent regressions.

Thanks,
Rafael
