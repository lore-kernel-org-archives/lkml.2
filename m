Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab2DNJMw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 05:12:52 -0400
Received: from kamaji.grokhost.net ([87.117.218.43]:41307 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab2DNJMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 05:12:51 -0400
From: Chris Boot <bootc@bootc.net>
To: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        nab@linux-iscsi.org, stefanr@s5r6.in-berlin.de,
        Chris Boot <bootc@bootc.net>
Subject: [PATCH 0/2] sbp-target: cleanup after merge into single file
Date: Sat, 14 Apr 2012 10:12:24 +0100
Message-Id: <1334394746-31738-1-git-send-email-bootc@bootc.net>
X-Mailer: git-send-email 1.7.9.5
References: <1334366583.12540.12.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to Nick Bellinger for doing the work for me and merging the
sbp-target code into single source/header files. This little series
does a bit of cleanup and updates the TODO file.

I'll also take this opportunity to add my sign-off to Nick's patch that
merges everything together, which this series is on top of:

	Acked-by: Chris Boot <bootc@bootc.net>

Cheers,
Chris

Cc: Andy Grover <agrover@redhat.com>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>


Chris Boot (2):
  sbp-target: minor cleanups after merging into single file
  sbp-target: update TODO file

 drivers/target/sbp/TODO         |    8 ++++----
 drivers/target/sbp/sbp_target.c |    6 +++---
 drivers/target/sbp/sbp_target.h |    3 ---
 3 files changed, 7 insertions(+), 10 deletions(-)

-- 
1.7.9.5

