Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab0CRR7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 13:59:49 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:37197 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab0CRR7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 13:59:46 -0400
Subject: [PATCH v2 4/4] MAINTAINERS: remove obsolete HPET ACPI entry
To: Clemens Ladisch <clemens@ladisch.de>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Venkatesh Pallipadi <venki@google.com>, Vojtech Pavlik <vojtech@suse.cz>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Date: Thu, 18 Mar 2010 11:59:45 -0600
Message-ID: <20100318175945.15143.34498.stgit@bob.kio>
In-Reply-To: <20100318175852.15143.2124.stgit@bob.kio>
References: <20100318175852.15143.2124.stgit@bob.kio>
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

