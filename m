Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab0GAPE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:04:29 -0400
Received: from cantor.suse.de ([195.135.220.2]:50877 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756547Ab0GAPCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:02:54 -0400
From: Thomas Renninger <trenn@suse.de>
To: lenb@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       platform-driver-x86@vger.kernel.org, astarikovskiy@suse.de
Subject: Provide /sys/../ec with read/write access and some cleanups
Date: Thu,  1 Jul 2010 17:02:44 +0200
Message-Id: <1277996570-2686-1-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are diffed against the test branch of the ACPI tree, but also
patch fine with 2.6.35-rc3.

I thought about tainting the kernel if someone writes to the EC, but as
userspace can also write to graphics IO, PCI config or MSRs, it shouldn't
matter that much.
Eventually this should still be added (by a separate patch), one can easily
confuse the EC to not switch on the fans anymore.

A small tool to read out and write to /sys/devices/system/ec/*/io can be
found here:
ftp://ftp.suse.com/pub/people/trenn/sources/ec/ec_access.c

Len: Can you apply these into your test branch and schedule them for linux-next
and 2.6.36 if there are no objections, please.

Thanks,

     Thomas

