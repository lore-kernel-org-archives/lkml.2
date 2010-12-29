Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab0L2X3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 18:29:53 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40332 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753860Ab0L2X3v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 18:29:51 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Miles Lane" <miles.lane@gmail.com>
References: <odW4v9b6arG.A.2bH.uE8GNB@chimera>
In-Reply-To: <odW4v9b6arG.A.2bH.uE8GNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <LbeBv-BNQpL.A.m1.6G8GNB@chimera>
Subject: [Bug #19052] 2.6.36-rc5-git1 -- [drm:i915_report_and_clear_eir] *ERROR* EIR stuck: 0x00000010, masking
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 30 Dec 2010 00:21:19 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.35 and 2.6.36.

The following bug entry is on the current list of known regressions
introduced between 2.6.35 and 2.6.36.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=19052
Subject		: 2.6.36-rc5-git1 -- [drm:i915_report_and_clear_eir] *ERROR* EIR stuck: 0x00000010, masking
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2010-09-22 23:47 (99 days old)
Message-ID	: <AANLkTikWQjUQjFJU9MO1+XbSLAEE-GARz+S+Dz2Fgu4h@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=128519926626322&w=2


