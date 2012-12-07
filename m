Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933615Ab2LGLeE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 06:34:04 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:36110 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932274Ab2LGLeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 06:34:02 -0500
Message-ID: <50C1D423.6000400@free.fr>
Date: Fri, 07 Dec 2012 12:33:55 +0100
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: local timers vs APIC question
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi All,

I have a question about the timers on the intel platform.

While looking at the /proc/interrupts on different hosts, I see for an
intel i7 or intel Xeon 5345, the IO-APIC-edge timer is rarely used and
the local timers are widely used but on Core 2 Duo T9500, the APIC timer
is more used than the local timers.

Why there is such difference ? Does anyone have a hint to investigate
why that happens ?

Thanks in advance

  -- Daniel
