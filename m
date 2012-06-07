Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab2FGUYE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 16:24:04 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56009 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab2FGUYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 16:24:01 -0400
Date: Thu, 7 Jun 2012 22:23:55 +0200
From: Andi Kleen <andi@firstfloor.org>
To: acme@redhat.com, jolsa@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org
Subject: perf user tool precise attribute broken in 3.5rc1+
Message-ID: <20120607202355.GQ27374@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With a perf user tool compiled from a 3.5rc1+ kernel I cannot
use the 'p' attribute anymore. Always get

ak@petrock:~> ./perf record -e cycles:p ./t

  Error: sys_perf_event_open() syscall returned with 22 (Invalid argument).  /bin/dmesg may provide additional information.

  Fatal: No CONFIG_PERF_EVENTS=y kernel support configured?

./t: Terminated

With an older perf it works, so the kernel is ok.

ak@petrock:~> ./perf record -e cycles:p ./t
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.005 MB perf.data (~217 samples) ]
ak@petrock:~> 


-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
