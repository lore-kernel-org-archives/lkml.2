Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab1ALGWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 01:22:12 -0500
Received: from vms173011pub.verizon.net ([206.46.173.11]:39144 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab1ALGWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 01:22:09 -0500
Date: Wed, 12 Jan 2011 01:22:01 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Thomas Renninger <trenn@suse.de>
Cc: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        stable@kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] X86: Cleanup idle= internal variables by getting rid of
 idle_halt idle_nomwait
In-reply-to: <201011051124.49973.trenn@suse.de>
Message-id: <alpine.LFD.2.02.1101120120370.19140@x980>
References: <201011021441.09258.trenn@suse.de>
 <alpine.LFD.2.00.1011030150560.3378@localhost.localdomain>
 <201011031706.15248.trenn@suse.de> <201011051124.49973.trenn@suse.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > That function and all these idle workaround flags
> > > need to be re-whacked.

> > Whatabout this (compile tested (on x86_64/ia64)).
> > Adding lkml as this affects x86 core code.
> as this mostly affects intel_idle and acpi processor driver,
> can you apply this one to your acpi test branch if you are
> ok with it.

Looks good to me, Thomas, thanks for the follow-up.

I don't think it needed for -stable, but it is a good cleanup
for upstream.

applied to idle-test.

thanks,
Len Brown, Intel Open Source Technology Center

