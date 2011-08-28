Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab1H1TpM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 15:45:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43598 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212Ab1H1Tos convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 15:44:48 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "=?utf-8?q?Toralf=20F=C3=B6rster?=" <toralf.foerster@gmx.de>
References: <Sm7qbRR0zn.A.yAG.LepWOB@chimera>
In-Reply-To: <Sm7qbRR0zn.A.yAG.LepWOB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <gUVi6eNP8RE.A.jjG.zepWOB@chimera>
Subject: [Bug #40072] suspend/resume problems w/ kernel 3.0 and a *docked* ThinkPad T400, unless iwlagn unloaded
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 28 Aug 2011 21:01:13 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.39 and 3.0.

The following bug entry is on the current list of known regressions
introduced between 2.6.39 and 3.0.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=40072
Subject		: suspend/resume problems w/ kernel 3.0 and a *docked* ThinkPad T400, unless iwlagn unloaded
Submitter	: Toralf Förster <toralf.foerster@gmx.de>
Date		: 2011-07-23 19:27 (37 days old)
Message-ID	: <201107232127.34255.toralf.foerster@gmx.de>
References	: http://marc.info/?l=linux-kernel&m=131144928023465&w=2


