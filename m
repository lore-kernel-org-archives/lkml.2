Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763Ab0EXQGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 12:06:47 -0400
Received: from lo.gmane.org ([80.91.229.12]:49565 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757739Ab0EXQGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 12:06:46 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
connect(): No such file or directory
From: Orion Poplawski <orion@cora.nwra.com>
Subject: Clock jumps
Date: Mon, 24 May 2010 16:06:32 +0000 (UTC)
Message-ID: <loom.20100524T171038-56@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 65.44.101.162 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.3) Gecko/20100403 Fedora/3.6.3-4.fc13 Firefox/3.6.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a KVM virtual machine running 2.6.33.4-95.fc13.x86_64 on a CentOS 5.5
host whose clock jumps about 8-12 hours a couple times a day.  I have no idea
what is causing it.  Fedora 12 and Centos 5.5 KVM machines run fine on the same
host.  Is there any debugging I can enable to see what is jumping the clock?

kvm-clock: cpu 0, msr 0:1ba4741, boot clock
kvm-clock: cpu 0, msr 0:1e15741, primary cpu clock
Switching to clocksource kvm-clock
rtc_cmos 00:01: setting system clock to 2010-05-20 16:59:48 UTC (1274374788)

Thanks,

 Orion

