Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab1ENW1q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 18:27:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51736 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754992Ab1ENW1a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 18:27:30 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Nick Bowler" <nbowler@elliptictech.com>
References: <So1vU2GC7XM.A.5wB.44vzNB@chimera>
In-Reply-To: <So1vU2GC7XM.A.5wB.44vzNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <HA8urZ3ZRcP.A.TvC.O6vzNB@chimera>
Subject: [Bug #33242] Lockdep splat in autofs with 2.6.39-rc2
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 15 May 2011 00:18:58 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.38.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33242
Subject		: Lockdep splat in autofs with 2.6.39-rc2
Submitter	: Nick Bowler <nbowler@elliptictech.com>
Date		: 2011-04-07 19:44 (38 days old)
Message-ID	: <20110407194403.GA29404@elliptictech.com>
References	: http://marc.info/?l=linux-kernel&m=130220545614682&w=2


