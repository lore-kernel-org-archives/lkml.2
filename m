Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab0EQDWg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 23:22:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:38349 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314Ab0EQDWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 23:22:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,244,1272870000"; 
   d="scan'208";a="798995095"
Subject: perf tool build error
From: Lin Ming <ming.m.lin@intel.com>
To: mingo@elte.hu, acme@redhat.com
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 May 2010 11:21:44 +0800
Message-Id: <1274066504.10439.3.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Build perf tool in latest tip tree(17efbf4) fails,

$ gcc --version
gcc (GCC) 4.3.2 20081105 (Red Hat 4.3.2-7)

cc1: warnings being treated as errors
util/newt.c: In function ‘objdump_line__show’:
util/newt.c:252: error: passing argument 1 of ‘SLsmg_printf’ discards qualifiers from pointer target type
util/newt.c:258: error: passing argument 1 of ‘SLsmg_write_nstring’ discards qualifiers from pointer target type
util/newt.c:262: error: passing argument 1 of ‘SLsmg_write_nstring’ discards qualifiers from pointer target type
util/newt.c:264: error: passing argument 1 of ‘SLsmg_write_nstring’ discards qualifiers from pointer target type
util/newt.c: In function ‘setup_browser’:
util/newt.c:998: error: passing argument 3 of ‘SLtt_set_color’ discards qualifiers from pointer target type
util/newt.c:998: error: passing argument 4 of ‘SLtt_set_color’ discards qualifiers from pointer target type
util/newt.c:999: error: passing argument 3 of ‘SLtt_set_color’ discards qualifiers from pointer target type
util/newt.c:999: error: passing argument 4 of ‘SLtt_set_color’ discards qualifiers from pointer target type
util/newt.c:1000: error: passing argument 3 of ‘SLtt_set_color’ discards qualifiers from pointer target type
util/newt.c:1000: error: passing argument 4 of ‘SLtt_set_color’ discards qualifiers from pointer target type
util/newt.c:1001: error: passing argument 3 of ‘SLtt_set_color’ discards qualifiers from pointer target type
util/newt.c:1001: error: passing argument 4 of ‘SLtt_set_color’ discards qualifiers from pointer target type
util/newt.c:1002: error: passing argument 3 of ‘SLtt_set_color’ discards qualifiers from pointer target type
util/newt.c:1002: error: passing argument 4 of ‘SLtt_set_color’ discards qualifiers from pointer target type

