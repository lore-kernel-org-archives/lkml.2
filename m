Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759875Ab1ENWus (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 18:50:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51998 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759788Ab1ENWuU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 18:50:20 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Florian Mickler" <florian@mickler.org>,
        "Igor Murzov" <e-mail@date.by>
References: <Zsp7lN2vZ2O.A.J7C.bQwzNB@chimera>
In-Reply-To: <Zsp7lN2vZ2O.A.J7C.bQwzNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <SFkDk2sBn_E.A.NBD.kQwzNB@chimera>
Subject: [Bug #34252] Unexpected behaviour when switching video cards with vga_switcheroo
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 15 May 2011 00:40:42 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.37 and 2.6.38.

The following bug entry is on the current list of known regressions
introduced between 2.6.37 and 2.6.38.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=34252
Subject		: Unexpected behaviour when switching video cards with vga_switcheroo
Submitter	: Igor Murzov <e-mail@date.by>
Date		: 2011-05-02 22:39 (13 days old)
Handled-By	: Florian Mickler <florian@mickler.org>
Patch		: https://bugzilla.kernel.org/attachment.cgi?id=57582


