Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab1H1ToI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 15:44:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43546 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893Ab1H1ToC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 15:44:02 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Witold Baryluk" <baryluk@smp.if.uj.edu.pl>
References: <Sm7qbRR0zn.A.yAG.LepWOB@chimera>
In-Reply-To: <Sm7qbRR0zn.A.yAG.LepWOB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <gUVi6eNP8RE.A.z7G.OfpWOB@chimera>
Subject: [Bug #39732] JBD: Spotted dirty metadata buffer (dev = dm-2, blocknr = 2512725). There's a risk of filesystem corruption in case of system crash.
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 28 Aug 2011 21:01:12 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.39 and 3.0.

The following bug entry is on the current list of known regressions
introduced between 2.6.39 and 3.0.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=39732
Subject		: JBD: Spotted dirty metadata buffer (dev = dm-2, blocknr = 2512725). There's a risk of filesystem corruption in case of system crash.
Submitter	: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Date		: 2011-07-22 04:22 (38 days old)


