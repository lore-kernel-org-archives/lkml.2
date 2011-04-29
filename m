Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073Ab1D2IdK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 04:33:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:41912 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753869Ab1D2IdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 04:33:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,286,1301900400"; 
   d="scan'208";a="685836906"
From: Lin Ming <ming.m.lin@intel.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] perf misc cleanup
Date: Fri, 29 Apr 2011 08:41:56 +0000
Message-Id: <1304066518-30420-1-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Arnaldo

Could you take below 2 one-line patches?

[RESEND PATCH 1/2] perf probe: Fix the missed parameter initialization
       [PATCH 2/2] perf annotate: Remove duplicate header file

Thanks,
Lin Ming
