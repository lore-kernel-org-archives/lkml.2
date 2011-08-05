Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab1HEVBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 17:01:20 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53334 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab1HEVBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 17:01:07 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6429"; a="108261127"
Message-ID: <3f4665f1a191945db7c1711ecd154509.squirrel@www.codeaurora.org>
Date: Fri, 5 Aug 2011 14:01:03 -0700 (PDT)
Subject: kdump: Trouble reading /dev/oldmem from capture kernel
From: "Seemanta Dutta" <seemanta@codeaurora.org>
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings kernel hackers,

I am trying to dump the raw memory from the /dev/oldmem device from within
a kexec()'ed capture kernel. But it seems to be that I can only read 4k of
data from /dev/oldmem. I am following the kdump documentation given in:
http://www.mjmwired.net/kernel/Documentation/kdump/. And according to the
documentation in the above link, /dev/oldmem *should* present the raw view
of memory.

Some details about my scenario:
1. Production kernel panics, and I boot into the dump capture kernel
without any issues.

2. Dump capture kernel provides two interfaces to access 'old' kernel
memory (as per kdump dpcumentation): /dev/oldmem and /proc/vmcore. The
latter works perfectly. But I am more interested in the raw memory, rather
than the core file.

My expectation in this scenario was that I would be able to access entire
physical RAM using the /dev/oldmem device. But turns out, I can't.

I would be grateful if anyone pointed out if I was doing something wrong
or missing something.

This is happening over ARM. Could that have to do something with this ?
Not sure if the ARM integration of KDUMP/KEXEC has something to do with
it.

Your help would be greatly appreciated!

regards,
Seemanta

--

Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum


