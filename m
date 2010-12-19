Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab0LSMkk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 07:40:40 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38397 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755389Ab0LSMka convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 07:40:30 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Christian Casteyde" <casteyde.christian@free.fr>
References: <wNJKqSoEutL.A.lKD.odfDNB@chimera>
In-Reply-To: <wNJKqSoEutL.A.lKD.odfDNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <6Ue85L6pKCJ.A.-WE.befDNB@chimera>
Subject: [Bug #24142] Crash at boot in udev while accessing bt848 device in 2.6.37-rc*
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 19 Dec 2010 13:34:41 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.36.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=24142
Subject		: Crash at boot in udev while accessing bt848 device in 2.6.37-rc*
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2010-11-30 20:50 (20 days old)
References	: https://bugzilla.kernel.org/show_bug.cgi?id=24602


