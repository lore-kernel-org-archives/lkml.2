Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab2BVIDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 03:03:35 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:29868 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab2BVIDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 03:03:33 -0500
X-AuditID: cbfee61a-b7b78ae000001ceb-68-4f44a153d40e
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Kevin Hilman <khilman@ti.com>, Jean Pihet <j-pihet@ti.com>,
        markgross <markgross@thegnar.org>, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com
Subject: [RFC PATCH 0/2] CPUFreq / Ondemand update
Date: Wed, 22 Feb 2012 17:03:33 +0900
Message-id: <1329897815-15871-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <CAJ0PZbSODSJvV-_Gje9Hm9Ek22Z9m+PAcsf071OCmAOtsnKzyg@mail.gmail.com>
References: <CAJ0PZbSODSJvV-_Gje9Hm9Ek22Z9m+PAcsf071OCmAOtsnKzyg@mail.gmail.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. A new sampling rate should be effective immediately at update.

2. The sampling rate may be controlled through QoS requests.


MyungJoo Ham (2):
  CPUfreq ondemand: update sampling rate without waiting for next
    sampling
  CPUfreq ondemand: handle QoS request on DVFS response latency

 drivers/cpufreq/cpufreq_ondemand.c |  150 ++++++++++++++++++++++++++++++++++-
 1 files changed, 145 insertions(+), 5 deletions(-)

-- 
1.7.4.1

