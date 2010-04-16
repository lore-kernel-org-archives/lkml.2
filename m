Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab0DPJLx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 05:11:53 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:59862 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab0DPJLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 05:11:52 -0400
Message-ID: <4BC829D1.5070001@petalogix.com>
Date: Fri, 16 Apr 2010 11:11:45 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: wuzhangjin@gmail.com, Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched_clock - microblaze
References: <4BC728DD.5020404@petalogix.com> <201004152152.03883.arnd@arndb.de> <4BC8024E.6020006@petalogix.com> <201004161037.26070.arnd@arndb.de>
In-Reply-To: <201004161037.26070.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Friday 16 April 2010, Michal Simek wrote:
>> Why is sched_clock called in init_idle? Do you get any non zero value on 
>> any ARCH?
> 
> Yes, some architectures return a real-time value here that starts before boot.
> Also, when the clock starts at boot time, there can be a significant time
> spent in the firmware and early kernel code before we get to init_idle.

ok. I will return 0 before timer initialization.

Thanks for explanation,
Michal

> 
> 	Arnd


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663
