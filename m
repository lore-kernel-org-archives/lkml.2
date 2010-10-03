Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab0JCVSq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 17:18:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39290 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755286Ab0JCVSo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 17:18:44 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "infernix" <infernix@infernix.net>,
        "Jesse Barnes" <jbarnes@virtuousgeek.org>
References: <-jYMINoCtaK.A.F5.8CPqMB@chimera>
In-Reply-To: <-jYMINoCtaK.A.F5.8CPqMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <TPWomcQcd8K.A.83B.iDPqMB@chimera>
Subject: [Bug #18742] PROBLEM: Kernel panic on 2.6.36-rc4 when loading intel_ips on Core i3 laptop
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  3 Oct 2010 23:19:07 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.35.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=18742
Subject		: PROBLEM: Kernel panic on 2.6.36-rc4 when loading intel_ips on Core i3 laptop
Submitter	: infernix <infernix@infernix.net>
Date		: 2010-09-15 14:35 (19 days old)
Message-ID	: <4C90D998.6050103@infernix.net>
References	: http://marc.info/?l=linux-kernel&m=128456187928496&w=2
Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>
Patch		: https://bugzilla.kernel.org/attachment.cgi?id=31112


