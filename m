Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab2FWNDm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 09:03:42 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186Ab2FWNDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 09:03:39 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        nyoushchenko@mvista.com
Subject: UBI fastmap updates 
Date: Sat, 23 Jun 2012 15:03:15 +0200
Message-Id: <1340456602-46050-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the next round of UBI fastmap updates.

The highlights are:
	- Fastmap produces anchor PEBs if none are available
	  (creating a fastmap on an image created by ubinize works now)
	- Fastmap is now able to reuse all PEBs if no empty PEBs are available
	- Minor fixes

If you want to test fastmap you can use my git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/rw/ubi2.git ubi2/v13

Enjoy!
//richard

[PATCH 1/7] UBI: Fastmap: Modify the WL sub-system to prodcue a free
[PATCH 2/7] UBI: Fastmap: Fix WARN_ON()
[PATCH 3/7] UBI: Fastmap: Ensure that not all anchor PEBs go into a
[PATCH 4/7] UBI: Fastmap: Fix ubi_assert()
[PATCH 5/7] UBI: Fastmap: Kill max_pnum logic
[PATCH 6/7] UBI: Fastmap: Reuse all fastmap PEB if no free PEBs are
[PATCH 7/7] UBI: Fastmap: Get rid of fm_pool_mutex
