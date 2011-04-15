Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab1DOLBF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 07:01:05 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6812 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934Ab1DOLBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 07:01:04 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 15 Apr 2011 04:01:02 -0700
From: wni@nvidia.com
To: khali@linux-fr.org, guenter.roeck@ericsson.com
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        olofj@chromium.org, achew@nvidia.com, Wei Ni <wni@nvidia.com>
Subject: [PATCH 0/3] hwmon (lm90) add some function for lm90.
Date: Fri, 15 Apr 2011 19:00:25 +0800
Message-Id: <1302865228-7185-1-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Ni <wni@nvidia.com>

*** BLURB HERE ***

Wei Ni (3):
  hwmon: (lm90) Add suspend/resume support
  hwmon (lm90) Support to configure nct1008 from platform data
  hwmon (lm90) Add alarm function for nct1008

 drivers/hwmon/lm90.c    |  161 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/nct1008.h |   39 +++++++++++
 2 files changed, 200 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/nct1008.h

