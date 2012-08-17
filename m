Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab2HQOHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 10:07:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59522 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310Ab2HQOHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 10:07:18 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH v1 0/3] firmware loader: fix build failure
Date: Fri, 17 Aug 2012 22:06:57 +0800
Message-Id: <1345212420-1707-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

These 3 patches fix build failure reported by Fengguang aginst
driver-core -next tree.

The 2nd patch introduces dpm_for_each_dev in drivers/base/power
to fix link failure if firmware loader is complied as moudle.

v1:
        - add 'static inline' on dpm_for_each_dev if !PM_SLEEP(2/3)
        - check 'fn' in dpm_for_each_dev(2/3)

Thanks,
--
Ming Lei


