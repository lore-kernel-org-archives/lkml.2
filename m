Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965191Ab0GPLLt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 07:11:49 -0400
Received: from cantor.suse.de ([195.135.220.2]:59078 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965143Ab0GPLLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 07:11:42 -0400
From: Thomas Renninger <trenn@suse.de>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: Version 2: Provide /sys/../ec with read/write access and some cleanups
Date: Fri, 16 Jul 2010 13:11:30 +0200
Message-Id: <1279278697-3694-1-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is againt the acpi test branch.
It would be great if these can be applied there.
Patches are test compiled, booted and I played a bit with reading
writing...

Changes to the previous patchset:
    - Use debugfs /sys/kernel/debug/ec/* instead of /sys/devices/...
    - Keep some EC Documentation in the thinkpad driver
    - Add Documentation/ABI describing the new interface

Possible further enhancements:
    - Expose EC Fields and make them read/writable
    - Allow userspace to switch on burst mode to be able to test
      EC burst transitions in userspace

Thanks,

       Thomas

