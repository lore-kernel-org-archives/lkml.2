Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967432Ab2ERU5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 16:57:17 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:53345 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933078Ab2ERU5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 16:57:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: [PATCH 0/2] ACPI / PM: Fixes related to new definitions of device power states
Date: Fri, 18 May 2012 22:58:56 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Lin Ming <ming.m.lin@intel.com>
References: <201205142253.57023.rjw@sisk.pl>
In-Reply-To: <201205142253.57023.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205182258.56497.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following two patches fix a couple of remaining issues that appeared
when the definitions of ACPI device power states were changed.

[1/2] - Fix messages printing power states in drivers/acpi/bus.c.
[2/2] - Fix the reading of device power states.

Thanks,
Rafael

