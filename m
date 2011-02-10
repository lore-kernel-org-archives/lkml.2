Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab1BJOPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 09:15:19 -0500
Received: from mga03.intel.com ([143.182.124.21]:65490 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188Ab1BJOPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 09:15:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,451,1291622400"; 
   d="scan'208";a="386884403"
Subject: [RFC] perf tool: load data variable symbols
From: Lin Ming <ming.m.lin@intel.com>
To: acme@redhat.com, Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
        Stephane Eranian <eranian@google.com>, fweisbec@gmail.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Feb 2011 22:15:33 +0800
Message-Id: <1297347333.2272.37.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

Currently, perf tool only load function symbols when parsing perf.data.

But it is also helpful if variable symbols can be loaded.

For example, Intel load latency monitoring facility records data linear
address of the load operation. It's useful if the data linear address is
resolved into symbol, just like functions.

enum map_type {
        MAP__FUNCTION = 0,
        MAP__VARIABLE,
};

We already have MAP__VARIABLE defined, although it's not used now.

For both kernel and userspace applications, we can load the variable
symbols from .data and .bss section.

What do you think?

Thanks,
Lin Ming


