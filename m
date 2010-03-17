Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab0CQRfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 13:35:30 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:49058 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115Ab0CQRfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 13:35:11 -0400
Subject: [PATCH 3/3] MAINTAINERS: remove obsolete HPET ACPI entry
To: Clemens Ladisch <clemens@ladisch.de>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-acpi@vger.kernel.org, Vojtech Pavlik <vojtech@suse.cz>,
       linux-kernel@vger.kernel.org,
       "Venkatesh Pallipadi \(Venki\)" <venkatesh.pallipadi@intel.com>
Date: Wed, 17 Mar 2010 11:35:10 -0600
Message-ID: <20100317173510.31124.64427.stgit@bob.kio>
In-Reply-To: <20100317173329.31124.69795.stgit@bob.kio>
References: <20100317173329.31124.69795.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Bob Picco is no longer at HP.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 MAINTAINERS |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)


diff --git a/MAINTAINERS b/MAINTAINERS
index 47cc449..30ba4e9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2664,11 +2664,6 @@ HPET:	x86_64
 M:	Vojtech Pavlik <vojtech@suse.cz>
 S:	Maintained
 
-HPET:	ACPI
-M:	Bob Picco <bob.picco@hp.com>
-S:	Maintained
-F:	drivers/char/hpet.c
-
 HPFS FILESYSTEM
 M:	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
 W:	http://artax.karlin.mff.cuni.cz/~mikulas/vyplody/hpfs/index-e.cgi

