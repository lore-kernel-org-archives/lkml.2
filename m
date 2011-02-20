Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab1BTQ5M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 11:57:12 -0500
Received: from mga03.intel.com ([143.182.124.21]:52821 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754351Ab1BTQ5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 11:57:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,195,1297065600"; 
   d="scan'208";a="391494898"
Subject: [PATCH 0/6] perf: offcore event monitoring patches
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Feb 2011 00:56:36 +0800
Message-Id: <1298220996.2318.61.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

Sorry for late update, I was mostly on vacation in the past months.

FYI, the previous version at below link
http://marc.info/?l=linux-kernel&m=129346414407543&w=2
[PATCH 0/7] perf: offcore and load latency monitoring patches

I need some time to add userspace perf tool support for load latency
monitoring, so for now I only post offcore patches here.

The most visible changes is adding a new field
perf_event_attr::event_extra for extra MSR encoding, which is the first
revision of the Andi's patch did. And also 

Peter,
This version has addressed the comments against last version, could you
please consider merging this series?

Thanks,
Lin Ming


