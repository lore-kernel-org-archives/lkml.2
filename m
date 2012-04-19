Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab2DSMIO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 08:08:14 -0400
Received: from smtp.nokia.com ([147.243.1.47]:17725 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754914Ab2DSMGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 08:06:40 -0400
From: Carlos Chinea <carlos.chinea@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, linus.walleij@linaro.org, artem.bityutskiy@linux.intel.com,
        shubhrajyoti@ti.com
Subject: [PATCH 0/6] HSI fixes for 3.4
Date: Thu, 19 Apr 2012 15:05:21 +0300
Message-Id: <1334837127-12931-1-git-send-email-carlos.chinea@nokia.com>
X-Mailer: git-send-email 1.7.5.4
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch set contains fixes for the issues found by Greg KH

https://lkml.org/lkml/2012/4/2/511
https://lkml.org/lkml/2012/4/2/512

I would like to get feedback from those patches and specially
from the hsi_event rework patch.

Br,
Carlos Chinea

Carlos Chinea (6):
  HSI: hsi: Rework hsi_controller release
  HSI: hsi: Fix error path cleanup on client registration
  HSI: hsi: Remove controllers and ports from the bus
  HSI: hsi: Rework hsi_event interface
  HSI: hsi_char: Remove max_data_size from sysfs
  HSI: Add HSI ABI documentation

 Documentation/ABI/testing/sysfs-bus-hsi |   19 +++
 drivers/hsi/clients/hsi_char.c          |    2 +-
 drivers/hsi/hsi.c                       |  223 ++++++++++++++++---------------
 include/linux/hsi/hsi.h                 |   31 +++--
 4 files changed, 155 insertions(+), 120 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-hsi

-- 
1.7.5.4

