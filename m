Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404Ab0IZU3O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 16:29:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42928 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758163Ab0IZU3K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 16:29:10 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Cesar Eduardo Barros" <cesarb@cesarb.net>
References: <MEG5YPP-fxC.A.vnD.So6nMB@chimera>
In-Reply-To: <MEG5YPP-fxC.A.vnD.So6nMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <sQALkqF1FWE.A.15D.bo6nMB@chimera>
Subject: [Bug #19062] Dirtiable inode bdi default != sb bdi btrfs
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 26 Sep 2010 22:04:15 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.35.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=19062
Subject		: Dirtiable inode bdi default != sb bdi btrfs
Submitter	: Cesar Eduardo Barros <cesarb@cesarb.net>
Date		: 2010-09-23 0:54 (4 days old)
Message-ID	: <4C9AA546.6050201@cesarb.net>
References	: http://marc.info/?l=linux-kernel&m=128520328929595&w=2


