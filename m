Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab2G0FB4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 01:01:56 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:40852 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab2G0FBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 01:01:53 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-53-501220ab7271
From: Chanwoo Choi <cw00.choi@samsung.com>
To: anton.vorontsov@linaro.org
Cc: cbouatmailru@gmail.com, jenny.tc@intel.com, ramakrishna.pallala@intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 0/2] charger-manager: Stop charging when charge cable is
 detached and code clean
Date: Fri, 27 Jul 2012 14:01:25 +0900
Message-id: <1343365285-3462-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJJMWRmVeSWpSXmKPExsVy+t9jAd3VCkIBBpfvilhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MjjVr2AtaWCvaNxxjbWDsY+li5OSQEDCReL93KiuELSZx4d56
	ti5GLg4hgUWMEr1djxhBEkICS5kkLs8KA7HZBLQk9r+4wQZiiwjISbxe+5cJpIFZ4BSjxKOL
	J5i7GDk4hAWSJObccACpYRFQlfjc8JQJxOYVcJF48uwOO8QyBYnWZYfYJzByL2BkWMUomlqQ
	XFCclJ5rpFecmFtcmpeul5yfu4kR7MFn0jsYVzVYHGIU4GBU4uGdISIUIMSaWFZcmXuIUYKD
	WUmE9zkfUIg3JbGyKrUoP76oNCe1+BCjNAeLkjivifdXfyGB9MSS1OzU1ILUIpgsEwenVAOj
	ze4/b4QMH926O2nTqV1B01/x+fLr/dQzsWm91h7BuqBiy9m5HQkB1rE/OKfJvzrxRyamuXl+
	7KpmbS3rpB2LGM/V8N08PTlF95aoyfzqOWwHw+X6/972nPU2XHIPV/0DC7uWKcZzZT3vTXTP
	cxBn9XnJckHl4bvc3UkTzE+fNdYrmX5oW1q3EktxRqKhFnNRcSIA20E7htwBAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fix bug related to stop charging when charger cable is
detached and check return value of regulator_enable/disable() function
to confirm correct operation of enabled or disabling regulator for
charging. Second patch is code clean which remove unnecessary variable
type.

Chanwoo Choi (2):
  charger-manager: Disable regulator for charging when charger cable is
    detached
  charger-manager: Use replacement variable to check state of battery

 drivers/power/charger-manager.c       |   21 ++++++++++++++++++---
 include/linux/power/charger-manager.h |    3 ---
 2 files changed, 18 insertions(+), 6 deletions(-)

