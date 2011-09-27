Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab1I0DZx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 23:25:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:16434 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417Ab1I0DZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 23:25:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,447,1312182000"; 
   d="scan'208";a="71015320"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>
Subject: 
Date: Mon, 26 Sep 2011 20:25:47 -0700
Message-Id: <1317093949-20219-1-git-send-email-dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.6.2
In-Reply-To: <1316582561-23066-1-git-send-email-john.stultz@linaro.org>
References: <1316582561-23066-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

I ran into a couple issues dealing with comments in the config fragments and
clean-up after taking a signal. The following patches should address these.

I would still like an option to use allnoconfig for defining truly minimal
configs, but my patches aren't doing quite what I want, so these will have to
follow later. Hopefully tomorrow.

Thanks,

Darren

