Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321Ab0LSMlh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 07:41:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38507 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932229Ab0LSMle convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 07:41:34 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "=?utf-8?q?T=C3=B5nu=20Raitviir?=" <jussuf@linux.ee>
References: <wNJKqSoEutL.A.lKD.odfDNB@chimera>
In-Reply-To: <wNJKqSoEutL.A.lKD.odfDNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <6Ue85L6pKCJ.A.tQD.sdfDNB@chimera>
Subject: [Bug #25012] BUG: i915 causes NULL pointer dereference in 2.6.37-rc5-git4
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 19 Dec 2010 13:34:46 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.36.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=25012
Subject		: BUG: i915 causes NULL pointer dereference in 2.6.37-rc5-git4
Submitter	: Tõnu Raitviir <jussuf@linux.ee>
Date		: 2010-12-15 12:48 (5 days old)
Message-ID	: <alpine.DEB.2.00.1012151238570.4797@jbbyvx.ohzcpyho.rr>
References	: http://www.spinics.net/lists/dri-devel/msg06282.html


