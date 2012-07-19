Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645Ab2GSU5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 16:57:05 -0400
Received: from manchmal.in-ulm.de ([217.10.9.201]:41585 "EHLO
	manchmal.in-ulm.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab2GSU5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 16:57:04 -0400
X-Greylist: delayed 512 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jul 2012 16:57:04 EDT
Date: Thu, 19 Jul 2012 22:48:29 +0200
From: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
To: John Stultz <johnstul@us.ibm.com>
Cc: stable@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/11] 3.2-stable: Fix for leapsecond caused
 hrtimer/futex issue
Message-ID: <1342730535@msgid.manchmal.in-ulm.de>
References: <1342508724-14527-1-git-send-email-johnstul@us.ibm.com>
 <50050FD9.3070403@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50050FD9.3070403@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Stultz wrote...

> Attached is the test case I used to reproduce and test the solution
> to the hard-hang deadlock.

I was wondering whether anybody managed to crash a virtualbox guest
using your program. No avail, using version 4.1.18 on the host and the
guest kernel running several 3.0.x (x < 38) kernels on both x32 and
x64, the guest utilies were stopped. Rather a fun fact I guess but I
wanted to let you know.

All real hardware tested, including a dockstar on armel, crashed as
predicted, while 3.0.38-rc1 was immune.

    Christoph
