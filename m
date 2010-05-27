Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686Ab0E0Cmt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 22:42:49 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:52930 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932454Ab0E0Cmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 22:42:47 -0400
From: Len Brown <lenb@kernel.org>
To: x86@kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: idle-test patches queued for upstream
Date: Wed, 26 May 2010 22:42:23 -0400
Message-id: <1274928151-30919-1-git-send-email-lenb@kernel.org>
X-Mailer: git-send-email 1.7.1.231.gd0b16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please look over and test this patch set.
(If you test linux-next, you already have it)

There are a few simple patches, leading up to a new intel_idle driver.

Note that you can get the patch series as a single patch here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/idle/patches/2.6.34/idle-test-2.6.34.diff.gz

or pull from this git branch
git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-idle-2.6.git idle-test

Both are vs 2.6.34.

Why is it good to have a native intel_idle driver?

Basically, we think we can do better than ACPI.
Indeed, on my (production level commerically available) Nehalem desktop
the ACPI tables are broken and an ACPI OS idles at 100W.  With this
driver the box idles at 85W.

Thanks,
-Len

