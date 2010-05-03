Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759413Ab0ECNnK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 09:43:10 -0400
Received: from mailout2.zih.tu-dresden.de ([141.30.67.73]:38928 "EHLO
	mailout2.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932386Ab0ECNnH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 09:43:07 -0400
X-Greylist: delayed 1424 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 May 2010 09:43:07 EDT
Message-ID: <4BDECD66.2010906@tu-dresden.de>
Date: Mon, 03 May 2010 15:19:34 +0200
From: =?ISO-8859-15?Q?Ronny_Tsch=FCter?= <Ronny.Tschueter@tu-dresden.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.9.1.9) Gecko/20100317 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Tracing of power:power_start events doesn't work
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8BIT
X-TUD-Virus-Scanned: mailout2.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

i use kernel version 2.6.33.2 (x86-64, Core 2 Duo) and the perf events 
to track frequency and c states of my cpu. But if i want to trace 
power:power_start events, it does not work. After typing

echo "power:power_start" | sudo tee set_event

on the console, the trace doesn't contain such events. 
power:power_frequency and power:power_end events are reported correctly 
by the system. I read in the mailing list that Robert Schoene had a 
similiar problem, but with power:power_end events. Is there a known bug 
regarding to trace_power_start methods in process.c?

Bye Ronny

-- 
Ronny Tschueter

Technische Universität Dresden
Center for Information Services
and High Performance Computing (ZIH)
D-01062 Dresden
Germany

Office: Willersbau, room A31
Phone:	(+49) 351/463-35448
E-Mail: ronny.tschueter@tu-dresden.de
WWW:    http://www.tu-dresden.de/zih

