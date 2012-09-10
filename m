Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab2IJHyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 03:54:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:43486 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab2IJHx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 03:53:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,396,1344236400"; 
   d="scan'208";a="190784684"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: eranian@google.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
        andi@firstfloor.org, jolsa@redhat.com, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/3] perf: Add cpumask for uncore pmu
Date: Mon, 10 Sep 2012 15:53:48 +0800
Message-Id: <1347263631-23175-1-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset add a cpumask file to the uncore pmu sysfs directory.
If user doesn't explicitly specify CPU list, perf-stat only collects
uncore events on CPUs listed in the cpumask file.

As Stephane suggested, make perf-stat recognize wildcard in pmu name.
So we can easily measure event on all uncore boxes of same type.
	
Any comment is appreciated.
Thank you

