Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333Ab0GJAdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 20:33:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34571 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756293Ab0GJAdF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 20:33:05 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Marius Tolzmann" <tolzmann@molgen.mpg.de>
References: <xkNyyYrLiTN.A.s_G.7p7NMB@chimera>
In-Reply-To: <xkNyyYrLiTN.A.s_G.7p7NMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Hc02ROPrUsG.A.xEH.Fq7NMB@chimera>
Subject: [Bug #16348] kswapd continuously active when doing IO
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 10 Jul 2010 02:33:30 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.33 and 2.6.34.

The following bug entry is on the current list of known regressions
introduced between 2.6.33 and 2.6.34.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16348
Subject		: kswapd continuously active when doing IO
Submitter	: Marius Tolzmann <tolzmann@molgen.mpg.de>
Date		: 2010-07-07 10:58 (3 days old)


