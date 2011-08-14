Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab1HNTps (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 15:45:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40789 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754822Ab1HNTpo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 15:45:44 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Marc Koschewski" <marc@osknowledge.org>
References: <xuTC4jRtHbB.A.l4H.gMCSOB@chimera>
In-Reply-To: <xuTC4jRtHbB.A.l4H.gMCSOB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <bkwpSnItbJM.A.fLB.MOCSOB@chimera>
Subject: [Bug #38582] T510 43495KG won't resume with 32bit installation
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 14 Aug 2011 21:07:31 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.39 and 3.0.

The following bug entry is on the current list of known regressions
introduced between 2.6.39 and 3.0.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=38582
Subject		: T510 43495KG won't resume with 32bit installation
Submitter	: Marc Koschewski <marc@osknowledge.org>
Date		: 2011-06-30 22:39 (46 days old)


