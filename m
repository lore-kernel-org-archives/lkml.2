Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852Ab2EVStq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 14:49:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:51395 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747Ab2EVStp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 14:49:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="143430763"
Subject: Does perf inject preserve call chain data?
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, "; ak"@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 May 2012 11:49:45 -0700
Message-ID: <1337712585.3796.186.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo,

Wonder if perf inject munged the call chain data from perf record?

When I do
perf record -a -g -o - sleep 5 |perf inject -v -b  | perf report  -g -i -
I get a complain from perf report

Warning:
Selected -g but no callchain data. Did you call 'perf record' without -g?

Thanks.

Tim

