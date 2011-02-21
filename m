Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab1BUWqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 17:46:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45315 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752939Ab1BUWoX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 17:44:23 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, "carlos" <carlos.palma@ono.com>,
        "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>
References: <JwKd6rET8XO.A._ZC.gbuYNB@chimera>
In-Reply-To: <JwKd6rET8XO.A._ZC.gbuYNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <f14qsMvj2tF.A.6IE.rduYNB@chimera>
Subject: [Bug #25402] kernel (2.6.37-8-generic_amd64) panic on boot (with message "map_single: bounce buffer is not DMA'ble) - possible regression !!!
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 21 Feb 2011 23:37:06 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.36 and 2.6.37.

The following bug entry is on the current list of known regressions
introduced between 2.6.36 and 2.6.37.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=25402
Subject		: kernel (2.6.37-8-generic_amd64) panic on boot (with message "map_single: bounce buffer is not DMA'ble) - possible regression !!!
Submitter	: carlos <carlos.palma@ono.com>
Date		: 2010-12-21 19:58 (63 days old)
Handled-By	: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Patch		: https://patchwork.kernel.org/patch/522971/


