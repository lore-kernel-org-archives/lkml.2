Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab1BBXcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 18:32:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38271 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755556Ab1BBXcL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 18:32:11 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "=?utf-8?q?Bj=C3=B6rn=20Schlie=C3=9Fmann?=" <chronoss@gmx.de>,
        "CASTET Matthieu" <castet.matthieu@free.fr>
References: <QUnbpYCwS-F.A.vaC.VHeSNB@chimera>
In-Reply-To: <QUnbpYCwS-F.A.vaC.VHeSNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <ibChAs1xEQI.A.DVD.9HeSNB@chimera>
Subject: [Bug #27472] 5bd5a45 breaks resume from suspend on Thinkpad X201
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu,  3 Feb 2011 00:31:28 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.37.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=27472
Subject		: 5bd5a45 breaks resume from suspend on Thinkpad X201
Submitter	: Björn Schließmann <chronoss@gmx.de>
Date		: 2011-01-23 23:24 (11 days old)
Handled-By	: CASTET Matthieu <castet.matthieu@free.fr>
Patch		: https://bugzilla.kernel.org/attachment.cgi?id=45192


