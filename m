Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab2CKVyn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 17:54:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38364 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918Ab2CKVyT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 17:54:19 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Nageswara R Sastry" <rnsastry@linux.vnet.ibm.com>
References: <WuYv90FoNpB.A.O8.ktRXPB@chimera>
In-Reply-To: <WuYv90FoNpB.A.O8.ktRXPB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <C6gS2DkSgiG.A.uaB.ztRXPB@chimera>
Subject: [Bug #42850] [BUG] Kernel Bug at fs/btrfs/volumes.c:3638
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 11 Mar 2012 22:31:17 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 3.2.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: https://bugzilla.kernel.org/show_bug.cgi?id=42850
Subject		: [BUG] Kernel Bug at fs/btrfs/volumes.c:3638
Submitter	: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>
Date		: 2012-02-24 10:53 (17 days old)
Message-ID	: <4F476959.2010400@linux.vnet.ibm.com>
References	: http://marc.info/?l=linux-kernel&m=133008013332251&w=2


