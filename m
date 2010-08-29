Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab0H2Wws (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 18:52:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55212 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754100Ab0H2WwV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 18:52:21 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "Chris Wilson" <chris@chris-wilson.co.uk>,
        "Eric Anholt" <eric@anholt.net>, "Ivan Bulatovic" <combuster@gmx.com>,
        "Jesse Barnes" <jbarnes@virtuousgeek.org>
References: <4LwrqITm-eJ.A.r8G.eFueMB@chimera>
In-Reply-To: <4LwrqITm-eJ.A.r8G.eFueMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <4AUWBNzTkbD.A.5kH.vFueMB@chimera>
Subject: [Bug #17301] i915: 2.6.36-rc2 wrong resolution on gdm start
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 30 Aug 2010 00:36:37 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.35.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=17301
Subject		: i915: 2.6.36-rc2 wrong resolution on gdm start
Submitter	: Ivan Bulatovic <combuster@gmx.com>
Date		: 2010-08-24 1:00 (6 days old)
First-Bad-Commit: http://git.kernel.org/linus/9d0498a2bf7455159b317f19531a3e5db2ecc9c4
Message-ID	: <1282611655.2177.19.camel@localhost.localdomain>
References	: http://marc.info/?l=linux-kernel&m=128261168202306&w=2
Handled-By	: Chris Wilson <chris@chris-wilson.co.uk>


