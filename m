Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab1CFMZP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 07:25:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55831 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754596Ab1CFMXj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 07:23:39 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Guillaume Ayoub" <xovni@wanadoo.fr>
References: <t0W8Ea1iKeB.A.6xD.Lp3cNB@chimera>
In-Reply-To: <t0W8Ea1iKeB.A.6xD.Lp3cNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <GTlFTeOGjrB.A.ZCE.pp3cNB@chimera>
Subject: [Bug #30032] r8169: 60 seconds delay when resuming from suspend
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  6 Mar 2011 13:10:22 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.37.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=30032
Subject		: r8169: 60 seconds delay when resuming from suspend
Submitter	: Guillaume Ayoub <xovni@wanadoo.fr>
Date		: 2011-02-27 16:52 (8 days old)


