Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab1FZXBt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 19:01:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59741 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754765Ab1FZW6p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 18:58:45 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Martin Rogge" <marogge@onlinehome.de>
References: <fvHbBUhG0PD.A.IGE.HM7BOB@chimera>
In-Reply-To: <fvHbBUhG0PD.A.IGE.HM7BOB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Rm1pgFxEGUF.A._PE.UM7BOB@chimera>
Subject: [Bug #37752] Kernel Panic in drm_vblank_put+0x13/0x50 on P4 HT machine with 82915G/GV/910GL Integrated Graphics Controller
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 27 Jun 2011 00:35:16 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.38 and 2.6.39.

The following bug entry is on the current list of known regressions
introduced between 2.6.38 and 2.6.39.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=37752
Subject		: Kernel Panic in drm_vblank_put+0x13/0x50 on P4 HT machine with 82915G/GV/910GL Integrated Graphics Controller
Submitter	: Martin Rogge <marogge@onlinehome.de>
Date		: 2011-06-17 13:02 (10 days old)


