Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab0DBVdG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 17:33:06 -0400
Received: from fischerfamily.org ([71.216.156.246]:11330 "EHLO gw"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754809Ab0DBVc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 17:32:58 -0400
Subject: [PATCH 0/4]-V2 TPS6507x MFD driver
From: Todd Fischer <todd.fischer@ridgerun.com>
Reply-To: todd.fischer@ridgerun.com
To: linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com, sameo@linux.intel.com,
       broonie@opensource.wolfsonmicro.com,
       Liam Girdwood <lrg@slimlogic.co.uk>
In-Reply-To: <1269634292-29686-1-git-send-email-todd.fischer@ridgerun.com>
References: <1269634292-29686-1-git-send-email-todd.fischer@ridgerun.com>
Content-Type: text/plain
Organization: RidgeRun
Date: Fri, 02 Apr 2010 15:33:44 -0600
Message-Id: <1270244024.20290.8603.camel@sax-lx>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
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

