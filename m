Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab0DFU4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 16:56:49 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:49698 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744Ab0DFU4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 16:56:43 -0400
Date: Tue, 6 Apr 2010 15:55:56 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       alex.shi@intel.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Ma, Ling" <ling.ma@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: hackbench regression due to commit 9dfc6e68bfe6e
In-Reply-To: <alpine.DEB.2.00.1004061033330.18750@router.home>
Message-ID: <alpine.DEB.2.00.1004061552500.19151@router.home>
References: <1269506457.4513.141.camel@alexs-hp.sh.intel.com>  <alpine.DEB.2.00.1003250942080.2670@router.home>  <1269570902.9614.92.camel@alexs-hp.sh.intel.com>  <1270114166.2078.107.camel@ymzhang.sh.intel.com>  <alpine.DEB.2.00.1004011050340.16531@router.home>
  <1270195589.2078.116.camel@ymzhang.sh.intel.com>  <alpine.DEB.2.00.1004050853300.23149@router.home>  <i2z84144f021004051030k7ff5190cyc083aa12c552dfac@mail.gmail.com>  <4BBA8DF9.8010409@kernel.org> <1270542497.2078.123.camel@ymzhang.sh.intel.com>
 <alpine.DEB.2.00.1004061033330.18750@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We cannot reproduce the issue here. Our tests here (dual quad dell) show a
performance increase in hackbench instead.

Linux 2.6.33.2 #2 SMP Mon Apr 5 11:30:56 CDT 2010 x86_64 GNU/Linux
./hackbench 100 process 200000
Running with 100*40 (== 4000) tasks.
Time: 3102.142
./hackbench 100 process 20000
Running with 100*40 (== 4000) tasks.
Time: 308.731
./hackbench 100 process 20000
Running with 100*40 (== 4000) tasks.
Time: 311.591
./hackbench 100 process 20000
Running with 100*40 (== 4000) tasks.
Time: 310.200
./hackbench 10 process 20000
Running with 10*40 (== 400) tasks.
Time: 38.048
./hackbench 10 process 20000
Running with 10*40 (== 400) tasks.
Time: 44.711
./hackbench 10 process 20000
Running with 10*40 (== 400) tasks.
Time: 39.407
./hackbench 1 process 20000
Running with 1*40 (== 40) tasks.
Time: 9.411
./hackbench 1 process 20000
Running with 1*40 (== 40) tasks.
Time: 8.765
./hackbench 1 process 20000
Running with 1*40 (== 40) tasks.
Time: 8.822

Linux 2.6.34-rc3 #1 SMP Tue Apr 6 13:30:34 CDT 2010 x86_64 GNU/Linux
./hackbench 100 process 200000
Running with 100*40 (== 4000) tasks.
Time: 3003.578
./hackbench 100 process 20000
Running with 100*40 (== 4000) tasks.
Time: 300.289
./hackbench 100 process 20000
Running with 100*40 (== 4000) tasks.
Time: 301.462
./hackbench 100 process 20000
Running with 100*40 (== 4000) tasks.
Time: 301.173
./hackbench 10 process 20000
Running with 10*40 (== 400) tasks.
Time: 41.191
./hackbench 10 process 20000
Running with 10*40 (== 400) tasks.
Time: 41.964
./hackbench 10 process 20000
Running with 10*40 (== 400) tasks.
Time: 41.470
./hackbench 1 process 20000
Running with 1*40 (== 40) tasks.
Time: 8.829
./hackbench 1 process 20000
Running with 1*40 (== 40) tasks.
Time: 9.166
./hackbench 1 process 20000
Running with 1*40 (== 40) tasks.
Time: 8.681


