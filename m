Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab0LRTIv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 14:08:51 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:50398 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757057Ab0LRTIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 14:08:50 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 18 Dec 2010 20:08:37 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-pm@lists.linux-foundation.org, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [linux-pm] 2.6.37-rc5, pata_atiixp, DVD-ROM: kernel log flooded
 with "rpm_resume flags 0x4", "rpm_resume returns 1"
Message-ID: <20101218200837.03a23f62@stein>
In-Reply-To: <Pine.LNX.4.44L0.1012181259080.3334-100000@saphir.localdomain>
References: <20101217211556.2789cb80@stein>
	<Pine.LNX.4.44L0.1012181259080.3334-100000@saphir.localdomain>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 18 Alan Stern wrote:
> On Fri, 17 Dec 2010, Stefan Richter wrote:
> > On Dec 11 Rafael J. Wysocki wrote:
> > > I guess you have either CONFIG_PM_VERBOSE set or CONFIG_PM_DEBUG unset.
> > > 
> > > Which is the case?
> > 
> > I have both options off on 2.6.36 and older kernels.  I have both
> > options on on 2.6.37-rc5/-rc6 (because I wanted to check something
> > unrelated on 2.6.37).
> 
> These messages are produced by dev_dbg() calls.  The debug output is 
> enabled by either CONFIG_PM_VERBOSE or CONFIG_DEBUG_DRIVER.  Since you say 
> CONFIG_PM_VERBOSE is off, the other must be on -- unless maybe you have 
> CONFIG_DYNAMIC_DEBUG enabled.

No, CONFIG_PM_VERBOSE is of course _on_ in the kernel that spams the
log.  It is off in the older kernel that does not spam the log.
-- 
Stefan Richter
-=====-==-=- ==-- =--=-
http://arcgraph.de/sr/
