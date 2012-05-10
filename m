Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079Ab2EJOar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 10:30:47 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:56018 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825Ab2EJOao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 10:30:44 -0400
From: Borislav Petkov <bp@amd64.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: X86-ML <x86@kernel.org>, EDAC devel <linux-edac@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 0/9] x86, AMD, MCE: Thresholding cleanups
Date: Thu, 10 May 2012 16:30:20 +0200
Message-Id: <1336660229-32644-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.9.3.362.g71319
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Ok,

so those are a bunch of patches which give the MCE thresholding code a
hard look and a scrubbing to remove a couple of annoyances like sysfs
warnings when running CPU off-/online tests and the threshold_bank4 node
under /sys/devices/system/machinecheck/ is a symlink.

It also gives proper names to the thresholding banks instead of simply
enumerating them, see patch 8/9 for details.

It is tested on all our families >= K8 so if there are no objections,
I'd like to send it upwards next week and maybe even hit the upcoming
merge window, we'll see.

Thanks.
