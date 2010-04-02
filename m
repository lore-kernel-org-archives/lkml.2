Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab0DBVgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 17:36:51 -0400
Received: from fischerfamily.org ([71.216.156.246]:11490 "EHLO gw"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754253Ab0DBVgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 17:36:45 -0400
From: Todd Fischer <todd.fischer@ridgerun.com>
To: linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com, sameo@linux.intel.com,
       lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
       todd.fischer@ridgerun.com
Subject: [PATCH 0/4]-V2 TPS6507x MFD driver
Date: Fri,  2 Apr 2010 15:37:29 -0600
Message-Id: <1270244253-4234-1-git-send-email-todd.fischer@ridgerun.com>
X-Mailer: git-send-email 1.6.0.4
X-SA-Exim-Connect-IP: 10.0.0.3
X-SA-Exim-Mail-From: todd.fischer@ridgerun.com
X-SA-Exim-Scanned: No (on gw); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the second posting of the TPS6507x driver set.  I have
incorporated Mark Brown's feedback and retested.  Patches 3 and
5 have been combined so there are only 4 patches in the series now.

The TPS6507x family of Texas Instruments power management ICs (pmic) are
multi-function chips that include voltage regulation and touch screen
controller capabilities.  This patch set adds a TPS6507x multi-function
device driver and change the TPS6507x regulator driver to use the
TPS6507x MFD driver instead of interacting with the chip directly.  The
changes are needed before a touch screen driver can be added.

The patch set applies cleanly to the MFD repository:
git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git  If the
MFD and voltage regulator maintainer would prefer I post patches for a
different repository, please let me know.

The TPS6507x touch screen input driver will be posted to
linux-input@vger.kernel.org list.
