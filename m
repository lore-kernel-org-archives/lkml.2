Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab2HUGPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 02:15:38 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:36164 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab2HUGPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 02:15:36 -0400
X-AuditID: cbfee61a-b7fc66d0000043b7-4f-50332786e35b
From: Chanwoo Choi <cw00.choi@samsung.com>
To: sameo@linux.intel.com
Cc: gregkh@linuxfoundation.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 0/2] mfd: MAX77693: Fix bug
Date: Tue, 21 Aug 2012 15:15:47 +0900
Message-id: <1345529747-24808-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFJMWRmVeSWpSXmKPExsVy+t9jAd02deMAg5sbtC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG44//WAtWslZcntzG3MC4lKWLkZNDQsBE4tzuE2wQtpjEhXvr
	wWwhgUWMEls+GnYxcgHZS5kkTv6/zASSYBPQktj/4gZYkYiApMSzx+sYQYqYBWYzSlx70MQM
	khAW0Ja40f8erIFFQFXi87OVjCA2r4CrxKH3/xkhtilItC47xD6BkXsBI8MqRtHUguSC4qT0
	XEO94sTc4tK8dL3k/NxNjGAfPpPawbiyweIQowAHoxIP749FRgFCrIllxZW5hxglOJiVRHgb
	GYwDhHhTEiurUovy44tKc1KLDzFKc7AoifPy9xkGCAmkJ5akZqemFqQWwWSZODilGhiLC+7f
	jK6fvzIrL/OWQdf/uerCOdV7/A0/96gcnDQvdFZ+06OrDuFyNXWuS2fHMS6MfJeyxvIq//t6
	2Vfi0Y/vqZpc36GTcE1U3E3nt9TfGDnThF3Hzpx9WlG2/tSvytRt9VUH7M5fWh54J2LdyvtP
	Rc9Pll69XN1aMvSksM73joZk25SNDKJKLMUZiYZazEXFiQAwQ9O83QEAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fix bug of Maxim MAX77693 chip. First patch unmask interrupt
masking bit for charger/flas/muic device of Maxim MAX77693 and second patch
remove NULL pointer error when mfd-max77693 driver initialize irqs of Maxim
MAX77693 devices.

Chanwoo Choi (2):
  mfd: MAX77693: Fix bug of interrupt handlding for MAX77693 devices
  mfd: MAX77693: Fix NULL pointer error when initialize irqs of Maxim
    MAX77693

 drivers/extcon/extcon-max77693.c |   20 +++++++++++++-------
 drivers/mfd/max77693-irq.c       |   36 +++++++++++++++++++++++++++++++-----
 drivers/mfd/max77693.c           |   14 ++++++++++++++
 3 files changed, 58 insertions(+), 12 deletions(-)

