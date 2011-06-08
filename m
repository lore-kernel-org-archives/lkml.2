Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab1FHJo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 05:44:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:53043 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289Ab1FHJo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 05:44:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,337,1304319600"; 
   d="scan'208";a="13429053"
From: Heikki Krogerus <krohei@gmail.com>
To: Greg KH <gregkh@suse.de>, Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Support for SUSPEND and RESUME for USB chargers
Date: Wed,  8 Jun 2011 12:44:38 +0300
Message-Id: <1307526281-12125-1-git-send-email-krohei@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The charging should be prevented if the bus is suspended.

These notifications will come from the udc drivers. I'll create a
separate patch set for those, as I guess the maintainers of the
controller drivers need to approve those.


Heikki Krogerus (3):
  usb: otg: add events for suspend/resume states
  isp1704_charger: Handle suspended and resumed events
  twl4030_charger:  Handle suspended and resumed events

 drivers/power/isp1704_charger.c |   13 +++++++++++++
 drivers/power/twl4030_charger.c |    4 ++++
 include/linux/usb/otg.h         |    2 ++
 3 files changed, 19 insertions(+), 0 deletions(-)

-- 
1.7.4.1

