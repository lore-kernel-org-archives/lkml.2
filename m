Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab2B2Iyg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 03:54:36 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:15546 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945Ab2B2Iyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 03:54:32 -0500
X-AuditID: cbfee61b-b7c62ae000000989-57-4f4de7c786e7
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Kevin Hilman <khilman@ti.com>, Jean Pihet <j-pihet@ti.com>,
        markgross <markgross@thegnar.org>, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com
Subject: [PATCH v2 0/2] CPUFreq / Ondemand update
Date: Wed, 29 Feb 2012 17:54:40 +0900
Message-id: <1330505682-4794-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1329897815-15871-1-git-send-email-myungjoo.ham@samsung.com>
References: <1329897815-15871-1-git-send-email-myungjoo.ham@samsung.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. A new sampling rate should be effective immediately at update.

2. The sampling rate may be controlled through QoS requests.

Summory of changes since v1 patchset (RFC)
- Style changes
- Avoid the possiblity that a destroyed mutex may be used with QoS request.


MyungJoo Ham (2):
  CPUfreq ondemand: update sampling rate without waiting for next
    sampling
  CPUfreq ondemand: handle QoS request on DVFS response latency

 drivers/cpufreq/cpufreq_ondemand.c |  166 ++++++++++++++++++++++++++++++++++-
 1 files changed, 161 insertions(+), 5 deletions(-)

-- 
1.7.4.1

