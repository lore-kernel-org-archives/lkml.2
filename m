Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758325Ab1D2NIY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 09:08:24 -0400
Received: from lo.gmane.org ([80.91.229.12]:45600 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757569Ab1D2NIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 09:08:23 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: which kernel file contains /porc/acpi/thermal_zone/THRM/tempature
Date: Fri, 29 Apr 2011 13:37:55 +0100
Message-ID: <32oq88-mln.ln1@chipmunk.wormnet.eu>
References: <4DB9EEDD.9070407@nc.rr.com>
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: chipmunk.wormnet.eu
User-Agent: tin/1.9.6-20100522 ("Lochruan") (UNIX) (Linux/2.6.32-5-sparc64-smp (sparc64))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ralph Blach <chipperb@nc.rr.com> wrote:
>
> I have looked for this file quite a bit, but cannot find it.  Which 
> file contains /porc/acpi/thermal_zone/THRM/tempature so that I can 
> configure it in my kernel
> 
You have to look in the right places...
----
alex@berk:/usr/src$ grep "/proc/acpi/" -r linux-2.6-stable/Documentation | head -n1
linux-2.6-stable/Documentation/feature-removal-schedule.txt:What:       /proc/acpi/button
----

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/feature-removal-schedule.txt#l217

/sys/class/thermal/ is where you should be looking instead.

Cheers

-- 
Alexander Clouter
.sigmonster says: "A car is just a big purse on wheels."
                  		-- Johanna Reynolds

