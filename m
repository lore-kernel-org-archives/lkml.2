Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760459Ab2FUVuW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 17:50:22 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760357Ab2FUVuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 17:50:21 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com
Subject: 
Date: Thu, 21 Jun 2012 23:49:53 +0200
Message-Id: <1340315408-27375-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <UBI fastmap updates>
References: <UBI fastmap updates>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the next round of UBI fastmap updates.

The highlights are:
        - New self checks and a better fall back to scanning mechanism
        - The attaching by fastmap code got simplified
        - invalidate_fastmap() now really invalidates the fastmap B-)
        - Minor fixes

If you want to test fastmap you can use my git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/rw/ubi2.git ubi2/v12

Enjoy!
//richard

[PATCH 01/15] UBI: Fastmap: Relax EBA selfcheck
[PATCH 02/15] UBI: Fastmap: Coding style fix...
[PATCH 03/15] UBI: Fastmap: Modify ubi_attach() to force scanning if
[PATCH 04/15] UBI: Fastmap: Always refill pools upon writing a new
[PATCH 05/15] UBI: Fastmap: Amend locking
[PATCH 06/15] UBI: Fastmap: Call ensure_wear_leveling() again in
[PATCH 07/15] UBI: Fastmap: Add a workqueue to allow delayed fastmap
[PATCH 08/15] UBI: Fastmap: Fix lock inbalance
[PATCH 09/15] UBI: Fastmap: Simplify attach by fastmap
[PATCH 10/15] UBI: Fastmap: Remove unused variable
[PATCH 11/15] UBI: Fastmap: Remove unused label
[PATCH 12/15] UBI: Fastmap: Fix ai handling
[PATCH 13/15] UBI: Fastmap: Add new self check
[PATCH 14/15] UBI: Fastmap: Improve invalidate_fastmap()
[PATCH 15/15] UBI: Fastmap: Write a fastmap also while detaching.
