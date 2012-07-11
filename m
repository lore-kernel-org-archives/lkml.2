Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030221Ab2GKUoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 16:44:05 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:36184 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308Ab2GKUoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 16:44:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 0/2] PM: Fix build warnings for unusual configs
Date: Wed, 11 Jul 2012 22:47:21 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207112247.21693.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The following two patches fix build warnings for unusual combinations of
.config options.

[1/2] Fix build warnings in drivers/base/power/domain.c for CONFIG_PM_RUNTIME
      unset.
[2/2] Fix build warning in drivers/base/power/sysfs.c for CONFIG_PM_SLEEP unset.

Thanks,
Rafael

