Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab1LIXoL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 18:44:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51448 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633Ab1LIXoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 18:44:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-sh list" <linux-sh@vger.kernel.org>
Subject: [RFC][PATCH 0/4] PM / shmobile: Use PM QoS latency constraints in touchscreen driver
Date: Sat, 10 Dec 2011 00:42:44 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Magnus Damm <magnus.damm@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112100042.45168.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following series of patches updates the SH7372 PM domain's so that
A4R doesn't need to be turned on during system sleep, drops the SH7372's
PM domains stay_on flag and makes the touchscreen add a PM QoS constraint
on its I2C controller to prevent the A4R domain containing it from being
turned off (due to power management) when the touchscreen is active.

Comments welcome!

Thanks,
Rafael

