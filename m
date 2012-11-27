Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab2K0S3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 13:29:13 -0500
Received: from plane.gmane.org ([80.91.229.3]:57506 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755961Ab2K0S3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 13:29:11 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: memory allocation: smap large "Size", but unused
Date: Tue, 27 Nov 2012 19:28:52 +0100
Message-ID: <k930p2$8br$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: tc-gate1.pci.uni-heidelberg.de
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm just investigating why a user space program has a rather large 
VmSize, but small VmRSS size. Looking into /proc/$pid/smaps I notice 
several areas with an size of about 64MB, but otherwise that area is 
unused. So far I did not find a way how to reproduce that with malloc() 
calls.

7ffd34021000-7ffd38000000 ---p 00000000 00:00 0
Size:              65404 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB


Any idea how to do such an allocation from user space?


Thanks,
Bernd

