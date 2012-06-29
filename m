Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab2F2PRd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 11:17:33 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755689Ab2F2POj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 11:14:39 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        nyoushchenko@mvista.com
Subject: UBI fastmap updates
Date: Fri, 29 Jun 2012 17:14:18 +0200
Message-Id: <1340982869-77042-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the next round of UBI fastmap updates.

Fastmap is now disabled by default.
If you attach an image it will not automatically convert it
to the fastmap format.
UBI has a new module parameter "fm_auto".
If set to 1 UBI will create a fastmap automatically on your
flash device.
Please see commit "Add a module parameter to enable fastmap"
for more details.

If you want to test fastmap you can use my git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/rw/ubi2.git ubi2/v15

Enjoy!
//richard

[PATCH 01/11] UBI: Fastmap: Fix mem leak in error path
[PATCH 02/11] UBI: Fastmap: Amend self_check_eba()
[PATCH 03/11] UBI: Fastmap: Remove forward declaration
[PATCH 04/11] UBI: Fastmap: Move fastmap specific code into
[PATCH 05/11] UBI: Fastmap: Kill TODO
[PATCH 06/11] UBI: Fastmap: Remove unused variable
[PATCH 07/11] UBI: Fastmap: Fix scan regression
[PATCH 08/11] ubi: fastmap: Remove 'ubi' parameter of 'destroy_ai()'
[PATCH 09/11] ubi: fastmap: Do not free 'ai' in 'scan_all()'
[PATCH 10/11] UBI: Fastmap: Disable fastmap per default
[PATCH 11/11] UBI: Fastmap: Add a module parameter to enable fastmap
