Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107Ab1AJWtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 17:49:32 -0500
Received: from vms173009pub.verizon.net ([206.46.173.9]:57843 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091Ab1AJWtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 17:49:31 -0500
Date: Mon, 10 Jan 2011 17:49:07 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH] cpuidle: Make cpuidle_enable_device() call poll_idle_init()
In-reply-to: <201101080029.20744.rjw@sisk.pl>
Message-id: <alpine.LFD.2.02.1101101747530.7945@x980>
References: <201101080029.20744.rjw@sisk.pl>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

works for me!

/sys/devices/system/cpu/cpu0/cpuidle/state0/desc:<null>
/sys/devices/system/cpu/cpu0/cpuidle/state0/latency:0
/sys/devices/system/cpu/cpu0/cpuidle/state0/name:<null>
/sys/devices/system/cpu/cpu0/cpuidle/state0/power:4294967295
/sys/devices/system/cpu/cpu0/cpuidle/state0/time:1715
/sys/devices/system/cpu/cpu0/cpuidle/state0/usage:8

becomes

/sys/devices/system/cpu/cpu0/cpuidle/state0/desc:CPUIDLE CORE POLL IDLE
/sys/devices/system/cpu/cpu0/cpuidle/state0/latency:0
/sys/devices/system/cpu/cpu0/cpuidle/state0/name:C0
/sys/devices/system/cpu/cpu0/cpuidle/state0/power:4294967295
/sys/devices/system/cpu/cpu0/cpuidle/state0/time:28716
/sys/devices/system/cpu/cpu0/cpuidle/state0/usage:11

thanks,
Len Brown, Intel Open Source Technology Center

