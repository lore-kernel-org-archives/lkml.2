Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab0ITUU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 16:20:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52040 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757526Ab0ITUUZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 16:20:25 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Rolf Eike Beer" <eike-kernel@sf-tec.de>
References: <r2gGqgg1zFC.A.LrE.w97lMB@chimera>
In-Reply-To: <r2gGqgg1zFC.A.LrE.w97lMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <aRnAGz9xZ8K.A.zpF.2-7lMB@chimera>
Subject: [Bug #16537] TREE_RCU hangs at boot
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 20 Sep 2010 21:57:19 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.34 and 2.6.35.

The following bug entry is on the current list of known regressions
introduced between 2.6.34 and 2.6.35.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16537
Subject		: TREE_RCU hangs at boot
Submitter	: Rolf Eike Beer <eike-kernel@sf-tec.de>
Date		: 2010-08-07 12:18 (45 days old)
Handled-By	: Paul E. McKenney <paulmck@linux.vnet.ibm.com>


