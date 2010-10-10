Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719Ab0JJRye (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 13:54:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60915 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758204Ab0JJRxt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 13:53:49 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Miles Lane" <miles.lane@gmail.com>
References: <v0Rsc8XZnFC.A.-xF.oqfsMB@chimera>
In-Reply-To: <v0Rsc8XZnFC.A.-xF.oqfsMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <xpndfyzv9iD.A.cnG.IrfsMB@chimera>
Subject: [Bug #19052] 2.6.36-rc5-git1 -- [drm:i915_report_and_clear_eir] *ERROR* EIR stuck: 0x00000010, masking
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 10 Oct 2010 19:51:49 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.35.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=19052
Subject		: 2.6.36-rc5-git1 -- [drm:i915_report_and_clear_eir] *ERROR* EIR stuck: 0x00000010, masking
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2010-09-22 23:47 (19 days old)
Message-ID	: <AANLkTikWQjUQjFJU9MO1+XbSLAEE-GARz+S+Dz2Fgu4h@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=128519926626322&w=2


