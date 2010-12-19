Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945Ab0LSMlC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 07:41:02 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38457 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756907Ab0LSMk7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 07:40:59 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Alex Deucher" <alexdeucher@gmail.com>,
        "Dave Airlie" <airlied@redhat.com>,
        "Luca Tettamanti" <kronos.it@gmail.com>
References: <wNJKqSoEutL.A.lKD.odfDNB@chimera>
In-Reply-To: <wNJKqSoEutL.A.lKD.odfDNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <6Ue85L6pKCJ.A.4-D.NefDNB@chimera>
Subject: [Bug #24462] r600: spread spectrum: flickering screen (bisected)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 19 Dec 2010 13:34:42 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.36.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=24462
Subject		: r600: spread spectrum: flickering screen (bisected)
Submitter	: Luca Tettamanti <kronos.it@gmail.com>
Date		: 2010-12-08 16:18 (12 days old)
First-Bad-Commit: http://git.kernel.org/linus/ba032a58d1f320039e7850fb6e8651695c1aa571
Handled-By	: Alex Deucher <alexdeucher@gmail.com>
Patch		: https://bugzilla.kernel.org/attachment.cgi?id=39372


