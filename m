Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab0JCVzu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 17:55:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39470 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258Ab0JCVw4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 17:52:56 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Anisse Astier" <anisse@astier.eu>, "Eric Anholt" <eric@anholt.net>,
        "Tim Gardner" <tim.gardner@canonical.com>
References: <OjxVjYbf_EJ.A.ReC.pTPqMB@chimera>
In-Reply-To: <OjxVjYbf_EJ.A.ReC.pTPqMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <N9RAiGGLCfN.A.v9C.bUPqMB@chimera>
Subject: [Bug #16891] Kernel panic while loading intel module during boot
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  3 Oct 2010 23:53:02 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.34 and 2.6.35.

The following bug entry is on the current list of known regressions
introduced between 2.6.34 and 2.6.35.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16891
Subject		: Kernel panic while loading intel module during boot
Submitter	: Anisse Astier <anisse@astier.eu>
Date		: 2010-08-24 13:19 (41 days old)


