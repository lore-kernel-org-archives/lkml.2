Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab2JCU0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 16:26:24 -0400
Received: from smtp.getmail.no ([84.208.15.66]:59460 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934Ab2JCU0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 16:26:23 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
In-reply-to: <1349146202.7086.23.camel@marge.simpson.net>
References: <op.wlf5j0i76426ze@localhost.localdomain>
 <1349064397.6957.26.camel@marge.simpson.net>
 <op.wlh4u2xj6426ze@millennium.getinternet.no>
 <1349146202.7086.23.camel@marge.simpson.net>
Subject: Doom 3 perfect on linux.
To: linux-kernel@vger.kernel.org
Date: Wed, 03 Oct 2012 22:26:20 +0200
From: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Message-id: <op.wlmdp6s06426ze@localhost.localdomain>
User-Agent: Opera Mail/11.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 100hz, shaved kernel, for lowest jitter, and maximal performance, and  
the following hardwirings in fair.c

unsigned int sysctl_sched_min_granularity =  1158500ULL;
unsigned int normalized_sysctl_sched_min_granularity = 1158500ULL;
unsigned int __read_mostly sysctl_sched_shares_window = 0UL;

I finally got doom 3 to run perfectly.

I just wanted you to know. Any comments to this email please.

An ubuntu distro-kernel with the same philosophy, can also be downloaded  
 from here

http://paradoxuncreated.com/tmp/linux-headers-3.5.4_3.5.4-10.00.Custom_amd64.deb
http://paradoxuncreated.com/tmp/linux-image-3.5.4_3.5.4-10.00.Custom_amd64.deb

Some more info: (not updated yet with the new kernel -  
http://paradoxuncreated.com/Blog/wordpress/?p=2268
(please disregard the high hz here, reducing hz gained better jitter  
levels than higher hz)

Peace Be With You.
