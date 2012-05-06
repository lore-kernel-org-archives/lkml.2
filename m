Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab2EFXuK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 19:50:10 -0400
Received: from plane.gmane.org ([80.91.229.3]:55203 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754639Ab2EFXuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 19:50:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Christoph Bartoschek <ponto@pontohonk.de>
Subject: Strange behaviour after uptime of 208-209 days
Date: Mon, 07 May 2012 01:33:06 +0200
Message-ID: <iaej79-g6o.ln1@homer.bruehl.pontohonk.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: p3e9bb537.dip.t-dialin.net
User-Agent: KNode/4.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

we run kernel 2.6.37.6 from opensuse 11.4. All machines with uptimes more 
than 208 days show strange behaviour. The scheduler seems to avoid some 
cores. For example on a 12 core machine only 3 cores are used. I see the 
following messages in the logfiles

May  6 04:16:50 r1106i14 kernel: [18446743865.627390] BUG: soft lockup - 
CPU#1 stuck for 4278190091s! [bonnRoute:12613]
May  6 04:16:51 r1106i14 kernel: [18446743866.001912] BUG: soft lockup - 
CPU#6 stuck for 4278190091s! [bonnRoute:25309]
May  6 04:16:51 r1106i14 kernel: [18446743866.676048] BUG: soft lockup - 
CPU#15 stuck for 4278190091s! [bonnRoute:28259]              
May  6 04:16:43 r1106i11 kernel: [18446743821.077585] BUG: soft lockup - 
CPU#2 stuck for 4278190091s! [chipbench:14254]
May  6 04:16:43 r1106i11 kernel: [18446743821.152489] BUG: soft lockup - 
CPU#3 stuck for 4278190091s! [chipbench:14246]
May  6 04:16:43 r1106i11 kernel: [18446743821.227393] BUG: soft lockup - 
CPU#4 stuck for 4278190091s! [chipbench:14220]
May  6 04:16:44 r1106i11 kernel: [18446743821.302297] BUG: soft lockup - 
CPU#5 stuck for 4278190091s! [chipbench:14271]
May  6 04:16:44 r1106i11 kernel: [18446743821.452108] BUG: soft lockup - 
CPU#7 stuck for 4278190092s! [chipbench:14190]
May  6 04:16:44 r1106i11 kernel: [18446743821.527011] BUG: soft lockup - 
CPU#8 stuck for 4278190092s! [chipbench:14173]
May  6 04:16:44 r1106i11 kernel: [18446743821.601915] BUG: soft lockup - 
CPU#9 stuck for 4278190091s! [chipbench:14162]
May  6 04:16:44 r1106i11 kernel: [18446743821.676820] BUG: soft lockup - 
CPU#10 stuck for 4278190091s! [chipbench:14296]
May  6 04:16:44 r1106i11 kernel: [18446743821.751724] BUG: soft lockup - 
CPU#11 stuck for 4278190091s! [chipbench:14203]


The representation of the kernel time stamp is near to 2^64. Is there an 
integer overflow involved?

Could you please tell me which kernel version fixed this bug?

Thanks
Christoph

