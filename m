Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165Ab0ITTbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 15:31:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51624 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757343Ab0ITTas convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 15:30:48 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Stefan Richter" <stefanr@s5r6.in-berlin.de>
References: <1fwtoy8sG5H.A.veG.9D7lMB@chimera>
In-Reply-To: <1fwtoy8sG5H.A.veG.9D7lMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Wn2eLj_6KZG.A._MH.jE7lMB@chimera>
Subject: [Bug #17752] 2.6.36-rc3: inconsistent lock state (iprune_sem, shrink_icache_memory)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 20 Sep 2010 21:08:05 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.35.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=17752
Subject		: 2.6.36-rc3: inconsistent lock state (iprune_sem, shrink_icache_memory)
Submitter	: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date		: 2010-09-01 6:37 (20 days old)
Message-ID	: <tkrat.ed8eda6bc8ffe64e@s5r6.in-berlin.de>
References	: http://marc.info/?l=linux-kernel&m=128332308528119&w=2


