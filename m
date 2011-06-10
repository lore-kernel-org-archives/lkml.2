Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab1FJIYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 04:24:18 -0400
Received: from lucidpixels.com ([75.144.35.66]:58525 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab1FJIYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 04:24:15 -0400
Date: Fri, 10 Jun 2011 04:24:14 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Thomas Gleixner <tglx@linutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>, Alan Piszcz <ap@solarrain.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: 2.6.39: crash w/threadirqs option enabled
In-Reply-To: <alpine.DEB.2.02.1106100414550.32450@p34.internal.lan>
Message-ID: <alpine.DEB.2.02.1106100421560.32450@p34.internal.lan>
References: <alpine.DEB.2.02.1105200405210.24033@p34.internal.lan> <alpine.LFD.2.02.1105201445300.3078@ionos> <alpine.DEB.2.02.1105200850080.19553@p34.internal.lan> <alpine.LFD.2.02.1105201528500.3078@ionos> <alpine.DEB.2.02.1105200945300.19553@p34.internal.lan>
 <alpine.LFD.2.02.1105201712501.3078@ionos> <alpine.DEB.2.02.1105201210030.19553@p34.internal.lan> <alpine.LFD.2.02.1105201819310.3078@ionos> <alpine.DEB.2.02.1106100414550.32450@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 10 Jun 2011, Justin Piszcz wrote:
>
> Hi,
>
> Crashed again and it rebooted too:
>
> reboot   system boot  2.6.39             Thu Jun  9 23:58 - 04:05  (04:06) 
> user1      pts/0        X                Thu Jun  9 19:25 - 19:30  (00:04)
> user1      pts/10       X                Thu Jun  9 18:23 - crash  (05:35)
>
> Any thoughts on what could be causing this?
> Should I go back to 2.6.38?
>

I have a lot of USB devices attached, perhaps that is what's causing the
crashes, I will disconnect some of them and see if there is another crash.

Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 002: ID 8087:0020 Intel Corp. Integrated Rate Matching Hub
Bus 002 Device 002: ID 8087:0020 Intel Corp. Integrated Rate Matching Hub
Bus 001 Device 003: ID 2001:f103 D-Link Corp. DUB-H7 7-port USB 2.0 hub
Bus 001 Device 004: ID 2001:f103 D-Link Corp. DUB-H7 7-port USB 2.0 hub
Bus 001 Device 005: ID 0764:0501 Cyber Power System, Inc. CP1500 AVR UPS
Bus 001 Device 006: ID 413c:1002 Dell Computer Corp. Keyboard Hub
Bus 002 Device 003: ID 0a12:0001 Cambridge Silicon Radio, Ltd Bluetooth Dongle (HCI mode)
Bus 001 Device 007: ID 067b:2303 Prolific Technology, Inc. PL2303 Serial Port
Bus 001 Device 008: ID 0424:2502 Standard Microsystems Corp. 
Bus 001 Device 009: ID 054c:002c Sony Corp. USB Floppy Disk Drive
Bus 001 Device 010: ID 413c:2002 Dell Computer Corp. SK-8125 Keyboard
Bus 001 Device 011: ID 0461:4d15 Primax Electronics, Ltd Dell Optical Mouse
Bus 001 Device 012: ID 0424:2602 Standard Microsystems Corp. USB 2.0 Hub
Bus 001 Device 013: ID 093b:0027 Plextor Corp. 
Bus 001 Device 014: ID 0424:2228 Standard Microsystems Corp. 9-in-2 Card Reader

Justin.

