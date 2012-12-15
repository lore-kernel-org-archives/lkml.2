Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533Ab2LOGDq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 01:03:46 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:38086 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750822Ab2LOGDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 01:03:44 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 0/5] staging/fwserial: Address reviewer comments
Date: Sat, 15 Dec 2012 01:03:14 -0500
Message-Id: <1355551400-8204-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.0.1
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Overdue respin.
v2 changes:
   Don't use 'card' when referring to firewire node
   Removed lower clamp in link_speed_to_max_payload()
   Ripped out the bandwidth limit logic
   Drop suggestion to integrate link_speed_to_max_payload()
     & device_max_receive()
   Note required minimum max_rec value for OHCI-compliant devices

Peter Hurley (6):
  staging/fwserial: Refine Kconfig help text
  staging/fwserial: Remove bandwidth limit logic
  staging/fwserial: Limit tx/rx to 1394-2008 spec maximum
  staging/fwserial: Update TODO file per reviewer comments
  staging/fwserial: Assume firmware is OHCI-complaint
  staging/fwserial: Drop suggestion for helper fn integration

 drivers/staging/fwserial/Kconfig    |  4 +++-
 drivers/staging/fwserial/TODO       | 16 +++-------------
 drivers/staging/fwserial/fwserial.c | 15 ++++++++-------
 drivers/staging/fwserial/fwserial.h | 17 +++++++----------
 4 files changed, 21 insertions(+), 31 deletions(-)

-- 
1.8.0.1

