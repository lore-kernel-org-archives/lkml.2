Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab2H3I7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 04:59:53 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:57269 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab2H3I7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 04:59:51 -0400
X-AuditID: cbfee61a-b7fc66d0000043b7-ea-503f2b86e628
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: myungjoo.ham@gmail.com, rjw@sisk.pl, kyungmin.park@samsung.com,
        khilman@ti.com, markgross@thegnar.org, jean.pihet@newoldbits.com,
        mturquette@ti.com, jonghwa3.lee@samsung.com
Subject: [PATCH v3 0/2] PM / devfreq: support PM-QoS at devfreq core.
Date: Thu, 30 Aug 2012 18:00:01 +0900
Message-id: <1346317203-7357-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPJMWRmVeSWpSXmKPExsVy+t9jQd02bfsAgyfzVC0u75rDZvG59wij
	A5PH501yAYxRXDYpqTmZZalF+nYJXBltZ+4wFvxjrdj14R5jA+M3li5GDg4JAROJmfNCuhg5
	gUwxiQv31rN1MXJxCAlMZ5TY2bEKymlhkjj3+yYzSBWbgK7E1g13WUBsEQEridP/O5hBipgF
	tjJKXDvRwAqSEBZwlThw4gJYA4uAqsTE95/BbF4Bd4nm+c8YIdYpSCy495ZtAiP3AkaGVYyi
	qQXJBcVJ6bmGesWJucWleel6yfm5mxjB3nwmtYNxZYPFIUYBDkYlHl6OTLsAIdbEsuLK3EOM
	EhzMSiK87Pz2AUK8KYmVValF+fFFpTmpxYcYpTlYlMR5nc4BVQukJ5akZqemFqQWwWSZODil
	GhhPX17143rgh+mRs6vOO6wXiXrFzJPG65u+RvTXpsKXL5My/i/v2Prtavatz1rqp/PfxOV9
	+mgaM3uRgMoEnxeHZoY9Pz0h5o3VT/4nbXJ8TzounrDjDuve3Jed8vjng5+bT27Z2PqirZ2V
	65r1gknXZoc+z/QUY/Ux+arx+ruI1Ka7n5QDXpQtVGIpzkg01GIuKk4EAPQQQWbiAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset enabled devfreq devices to handle QoS requests by simply
supplying a table of QoS values and minimum frequencies to support the
QoS values.

Major changes since the last patchset (v2-resend)
- Support per-dev QoS requests
- Removed dependencies on the QoS class definitions

The patchset is going to be shown at
http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/devfreq-for-next
within hours as well.

MyungJoo Ham (2):
  PM / devfreq: add global PM QoS support
  PM / devfreq: support per-dev PM-QoS in devfreq

 drivers/devfreq/devfreq.c |  135 +++++++++++++++++++++++++++++++++++++++++++-
 include/linux/devfreq.h   |   41 ++++++++++++++
 2 files changed, 172 insertions(+), 4 deletions(-)

-- 
1.7.4.1

