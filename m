Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030886Ab2HHVM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 17:12:28 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:49470 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001Ab2HHVMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 17:12:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] PM: Fix some unused function warnings for CONFIG_PM_SLEEP
Date: Wed, 8 Aug 2012 23:08:15 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208082308.15466.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The recent conversion to the PM handling based on struct dev_pm_ops
uncovered some code that is not used for CONFIG_PM_SLEEP unset, which
results in a number of new copiler warning.

Admittedly, I should have spotted those places before, but anyway
patches fixing those for ACPI, platform/x86 and tpm_tis follow.

Thanks,
Rafael

