Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab2BKTIK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 14:08:10 -0500
Received: from mail.wdtv.com ([66.118.69.84]:42695 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753990Ab2BKTII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 14:08:08 -0500
From: Gene Heskett <gene.heskett@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: OT question on top/htop/etc system monitors
Date: Sat, 11 Feb 2012 14:08:06 -0500
User-Agent: KMail/1.13.7 (Linux/2.6.38.8-pclos2.pae.bfs; KDE/4.6.5; i686; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201202111408.06101.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all;

Users of the RTAI facility to run certain processes on a cpu core that has 
been isolated by the boot parameter 'isolcpus=n' command need to be able to 
confirm that the process so launched is indeed using x% of that cpu core.

There doesn't appear to be any facility in such as htop, to actually 
determine this usage.  In fact, if we taskset the whole linuxcnc (was emc 
till the lawyers wrote) gkrellm is the only utility that does show any 
usage of that isolated core.  Then of course its quite high because every 
thread in the program is running on that core.

Is the monitoring of an isolcpus defined core even possible?

And if possible, could it be added to htop so it displays the core that the 
RTAI threads are running on?

It would sure give us another tool to help optimize this application.

Thanks and Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
My web page: <http://coyoteden.dyndns-free.com:85/gene>
We totally deny the allegations, and we're trying to identify the 
allegators.
