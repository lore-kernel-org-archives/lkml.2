Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab1CFMWa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 07:22:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55761 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753900Ab1CFMW1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 07:22:27 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Eric Whitney" <eric.whitney@hp.com>,
        "Lukas Czerner" <lczerner@redhat.com>
References: <t0W8Ea1iKeB.A.6xD.Lp3cNB@chimera>
In-Reply-To: <t0W8Ea1iKeB.A.6xD.Lp3cNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <GTlFTeOGjrB.A._lE.Mq3cNB@chimera>
Subject: [Bug #29402] kernel panics while running ffsb scalability workloads on 2.6.38-rc1 through -rc5
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  6 Mar 2011 13:10:19 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.37.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=29402
Subject		: kernel panics while running ffsb scalability workloads on 2.6.38-rc1 through -rc5
Submitter	: Eric Whitney <eric.whitney@hp.com>
Date		: 2011-02-18 21:47 (17 days old)
Handled-By	: Lukas Czerner <lczerner@redhat.com>
Patch		: https://bugzilla.kernel.org/attachment.cgi?id=49642


