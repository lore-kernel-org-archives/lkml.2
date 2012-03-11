Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab2CKVys (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 17:54:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38370 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087Ab2CKVy2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 17:54:28 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Soeren Sonnenburg" <sonne@debian.org>
References: <WuYv90FoNpB.A.O8.ktRXPB@chimera>
In-Reply-To: <WuYv90FoNpB.A.O8.ktRXPB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <C6gS2DkSgiG.A.XCB.otRXPB@chimera>
Subject: [Bug #42907] 3.3.0-rc5+git: WARNING: at drivers/gpu/drm/i915/i915_irq.c:652 ironlake_irq_handler+0x4ea/0x500()
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 11 Mar 2012 22:31:18 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 3.2.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: https://bugzilla.kernel.org/show_bug.cgi?id=42907
Subject		: 3.3.0-rc5+git: WARNING: at drivers/gpu/drm/i915/i915_irq.c:652 ironlake_irq_handler+0x4ea/0x500()
Submitter	: Soeren Sonnenburg <sonne@debian.org>
Date		: 2012-03-05 23:59 (7 days old)
Message-ID	: <1330991976.9223.16.camel@no>
References	: http://marc.info/?l=linux-kernel&m=133099242810332&w=2


