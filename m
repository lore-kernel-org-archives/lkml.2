Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751085Ab2E3EJB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 00:09:01 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:56258 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889Ab2E3EJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 00:09:00 -0400
Date: Wed, 30 May 2012 09:38:54 +0530
From: Pradeep Kumar Surisetty <psuriset@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: perf build failure
Message-ID: <20120530040854.GA4626@linux.vnet.ibm.com>
Reply-To: Pradeep Kumar Surisetty <psuriset@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12053004-5930-0000-0000-0000085B6C33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf build failed on 3.4.0+ linus tree. 
Error meesage seems like this

    LINK perf
    libperf.a(pmu.o): In function `pmu_format_parse':
    /home/linux/tools/perf/util/pmu.c:47: undefined reference to
    `perf_pmu_in'
    libperf.a(pmu-bison.o): In function `perf_pmu_parse':
    /home/linux/tools/perf/util/pmu-bison.c:1287: undefined reference to
    `perf_pmu_lex'
    collect2: ld returned 1 exit status
    make: *** [perf] Error 1

 


