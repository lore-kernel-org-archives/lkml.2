Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021Ab2FQUZl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 16:25:41 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:46769 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814Ab2FQUZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 16:25:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: platform-driver-x86@vger.kernel.org
Subject: [PATCH 0/5] platform / x86: Convert a few drivers to struct dev_pm_ops
Date: Sun, 17 Jun 2012 22:26:42 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Joey Lee <jlee@novell.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206172226.42729.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The following series of patches converts a few drivers under platform/x86
to using struct dev_pm_ops objects for power management istead of legacy
callbacks in struct platform_driver.

The ultimate goal of this will be to get rid of PM callbacks from the
platform bus type, which are only necessary because a number of drivers
still use the legacy hooks.

Admittedly, I don't have the hardware to test all of the changes, but
hopefully they are simple enough.

Please let me know if there are any objections.

Thanks,
Rafael

