Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab1FLVZG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 17:25:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50055 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259Ab1FLVYv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 17:24:51 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Nick Bowler" <nbowler@elliptictech.com>
References: <9NVbY1BZ_5D.A.2lE.jzS9NB@chimera>
In-Reply-To: <9NVbY1BZ_5D.A.2lE.jzS9NB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <kTLfM29CaqB.A.yCG.F2S9NB@chimera>
Subject: [Bug #33242] Lockdep splat in autofs with 2.6.39-rc2
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 12 Jun 2011 23:06:47 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.38 and 2.6.39.

The following bug entry is on the current list of known regressions
introduced between 2.6.38 and 2.6.39.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33242
Subject		: Lockdep splat in autofs with 2.6.39-rc2
Submitter	: Nick Bowler <nbowler@elliptictech.com>
Date		: 2011-04-07 19:44 (67 days old)
Message-ID	: <20110407194403.GA29404@elliptictech.com>
References	: http://marc.info/?l=linux-kernel&m=130220545614682&w=2
Patch		: http://marc.info/?l=linux-kernel&m=130342115008659&w=2


