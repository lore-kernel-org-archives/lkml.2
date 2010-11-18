Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933462Ab0KSANt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 19:13:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35151 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933152Ab0KSAIe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 19:08:34 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Ozan Caglayan" <ozan@pardus.org.tr>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>, 2010-04-22@ogre.sisk.pl,
        "21:50:19"@ogre.sisk.pl
References: <tTUH_XeInOH.A.dMF.c3b5MB@chimera>
In-Reply-To: <tTUH_XeInOH.A.dMF.c3b5MB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <t78YtCSuOqN.A.wuG.k4b5MB@chimera>
Subject: [Bug #20232] kworker consumes ~100% CPU on HP Elitebook 8540w running 2.6.36_rc6-git4
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 19 Nov 2010 00:53:36 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.35 and 2.6.36.

The following bug entry is on the current list of known regressions
introduced between 2.6.35 and 2.6.36.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=20232
Subject		: kworker consumes ~100% CPU on HP Elitebook 8540w running 2.6.36_rc6-git4
Submitter	: Ozan Caglayan <ozan@pardus.org.tr>
Date		: 2010-10-13 06:13 (37 days old)


