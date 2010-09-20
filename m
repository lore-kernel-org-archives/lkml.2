Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab0ITUUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 16:20:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52046 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932108Ab0ITUUd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 16:20:33 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Justin Piszcz" <jpiszcz@lucidpixels.com>
References: <r2gGqgg1zFC.A.LrE.w97lMB@chimera>
In-Reply-To: <r2gGqgg1zFC.A.LrE.w97lMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <aRnAGz9xZ8K.A.ogF.v-7lMB@chimera>
Subject: [Bug #16562] 2.6.35: cpu_idle bug report / on i7 870 cpu (x86_64)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 20 Sep 2010 21:57:20 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.34 and 2.6.35.

The following bug entry is on the current list of known regressions
introduced between 2.6.34 and 2.6.35.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16562
Subject		: 2.6.35: cpu_idle bug report / on i7 870 cpu (x86_64)
Submitter	: Justin Piszcz <jpiszcz@lucidpixels.com>
Date		: 2010-08-06 22:09 (46 days old)
Message-ID	: <alpine.DEB.2.00.1008061800530.5241@p34.internal.lan>
References	: http://marc.info/?l=linux-kernel&m=128113260904048&w=2


