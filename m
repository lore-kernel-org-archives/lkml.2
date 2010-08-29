Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab0H2X3z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 19:29:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55423 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754392Ab0H2X3v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 19:29:51 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Milan Bouchet-Valat" <nalimilan@club.fr>
References: <c1_O4wHrlB.A.63.mbueMB@chimera>
In-Reply-To: <c1_O4wHrlB.A.63.mbueMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <ByD_7B96czP.A.dBC.RdueMB@chimera>
Subject: [Bug #16488] [i915] Framebuffer ID error after suspend/hibernate leading to X crash
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 30 Aug 2010 01:13:32 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.34 and 2.6.35.

The following bug entry is on the current list of known regressions
introduced between 2.6.34 and 2.6.35.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16488
Subject		: [i915] Framebuffer ID error after suspend/hibernate leading to X crash
Submitter	: Milan Bouchet-Valat <nalimilan@club.fr>
Date		: 2010-08-01 08:55 (29 days old)


