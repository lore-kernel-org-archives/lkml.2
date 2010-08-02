Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab0HBWBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 18:01:21 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26389 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab0HBWBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 18:01:20 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6062"; a="49642668"
From: Patrick Pannuto <ppannuto@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: ppannuto@codeaurora.org, apw@canonical.com, corbet@lwn.net,
        arjan@linux.intel.com, linux-arm-msm@vger.kernel.org
Subject: [PATCH v3 0/4] Add usleep_range
Date: Mon,  2 Aug 2010 15:01:03 -0700
Message-Id: <1280786467-26999-1-git-send-email-ppannuto@codeaurora.org>
X-Mailer: git-send-email 1.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from v2:

	* Remove usleep API
		It seemed the weak consensus that the best way to
		force callers to consider the cost / implications
		of the underlying hrtimers was to leave only the
		range API as an option. Given the dangers of an
		implicit slack coupled with the potential
		proliferation of interrupts with no slack, forcing
		callers to supply a range seems the best choice.

	* Documentation updated to reflect changes

	* Fix checkpatch warnings to point to the correct file

[PATCH v3 1/4] timer: Added usleep_range timer
[PATCH v3 2/4] Documentation: Add timers/timers-howto.txt
[PATCH v3 3/4] Checkpatch: prefer usleep_range over udelay
[PATCH v3 4/4] Checkpatch: warn about unexpectedly long msleep's
