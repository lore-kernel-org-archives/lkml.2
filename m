Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab2JPVya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 17:54:30 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:20649 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286Ab2JPVyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 17:54:21 -0400
X-Greylist: delayed 3604 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Oct 2012 17:54:20 EDT
From: minyard@acm.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Subject: IPMI: Some minor fixes
Date: Tue, 16 Oct 2012 15:53:35 -0500
Message-id: <1350420820-7156-1-git-send-email-minyard@acm.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove some bogus docs, Fix ACPI/IPMI interactions, fix some warnings,
and add register spacing detection for PCI interfaces.

