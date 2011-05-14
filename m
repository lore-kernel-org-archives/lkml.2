Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814Ab1ENWi5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 18:38:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51800 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754992Ab1ENWit convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 18:38:49 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, "Meelis Roos" <mroos@linux.ee>
References: <So1vU2GC7XM.A.5wB.44vzNB@chimera>
In-Reply-To: <So1vU2GC7XM.A.5wB.44vzNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <HA8urZ3ZRcP.A.wKC.L5vzNB@chimera>
Subject: [Bug #34662] Warning at block/genhd.c:1556 disk_clear_events
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 15 May 2011 00:30:08 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.38.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=34662
Subject		: Warning at block/genhd.c:1556 disk_clear_events
Submitter	: Meelis Roos <mroos@linux.ee>
Date		: 2011-05-02 9:59 (13 days old)
Message-ID	: <alpine.SOC.1.00.1105021255400.6200@math.ut.ee>
References	: http://marc.info/?l=linux-kernel&m=130433037002610&w=2


