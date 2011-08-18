Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab1HRBzD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 21:55:03 -0400
Received: from emcscan.emc.com.tw ([192.72.220.5]:8104 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab1HRBy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 21:54:59 -0400
From: JJ Ding <jj_ding@emc.com.tw>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Seth Forshee <seth.forshee@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        Eric Piel <E.A.B.Piel@tudelft.nl>, Daniel Kurtz <djkurtz@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>, JJ Ding <jj_ding@emc.com.tw>
Subject: [PATCH 0/6] elantech: add support for newer generation hardware
Date: Thu, 18 Aug 2011 09:57:03 +0800
Message-Id: <1313632629-23603-1-git-send-email-jj_ding@emc.com.tw>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

This is a series of patches to add support for newer generation of ELAN
touchpad.

Patches #1~5 are essentially fixes and cleanups that pave the way for
patch #6, which really adds code for v3 hardware support.

Any comments, suggestions are welcome.

Thank you.

JJ Ding (6):
  Input: elantech - correct x, y value range for v2 hardware
  Input: elantech - use firmware provided x, y ranges
  Input: elantech - packet checking for v2 hardware
  Input: elantech - work around EC buffer
  Input: elantech - clean up elantech_init
  Input: elantech - add v3 hardware support

 Documentation/input/elantech.txt |  112 ++++++++++--
 drivers/input/mouse/elantech.c   |  373 ++++++++++++++++++++++++++++++++------
 drivers/input/mouse/elantech.h   |   15 ++-
 3 files changed, 426 insertions(+), 74 deletions(-)

-- 
1.7.4.1

