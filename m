Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab1BLXJk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 18:09:40 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39512 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042Ab1BLXI5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 18:08:57 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Michael Karcher" <kernel@mkarcher.dialup.fu-berlin.de>,
        "Norbert Preining" <preining@logic.at>
References: <NMZS1i37KEE.A.1eG.6_wVNB@chimera>
In-Reply-To: <NMZS1i37KEE.A.1eG.6_wVNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <8H3lez1sawF.A.G2H.LBxVNB@chimera>
Subject: [Bug #27702] regression 2.6.37 -> 2.6.38-rc1: after suspend backlight cannot be adjusted
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 13 Feb 2011 00:05:18 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.37.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=27702
Subject		: regression 2.6.37 -> 2.6.38-rc1: after suspend backlight cannot be adjusted
Submitter	: Norbert Preining <preining@logic.at>
Date		: 2011-01-21 1:55 (23 days old)
Message-ID	: <20110121015529.GD9796@gamma.logic.tuwien.ac.at>
References	: http://marc.info/?l=linux-kernel&m=129557717826819&w=2
Handled-By	: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
Patch		: https://patchwork.kernel.org/patch/499221/


