Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab1CFMTD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 07:19:03 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55705 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753652Ab1CFMS6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 07:18:58 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Santosh Shilimkar" <santosh.shilimkar@ti.com>
References: <t0W8Ea1iKeB.A.6xD.Lp3cNB@chimera>
In-Reply-To: <t0W8Ea1iKeB.A.6xD.Lp3cNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <GTlFTeOGjrB.A.7mF.Ss3cNB@chimera>
Subject: [Bug #27022] [REPORT] BUG: spinlock recursion on CPU#0, init/1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  6 Mar 2011 13:08:15 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.37.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=27022
Subject		: [REPORT] BUG: spinlock recursion on CPU#0, init/1
Submitter	: Santosh Shilimkar <santosh.shilimkar@ti.com>
Date		: 2011-01-10 15:33 (56 days old)
Message-ID	: <a7a9bdaa5936630925fb7ffd1a1795b1@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=129467294808655&w=2


