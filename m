Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab0FTWm2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 18:42:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58766 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754966Ab0FTWm0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 18:42:26 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Christian Kujau" <lists@nerdbynature.de>,
       "=?utf-8?q?Jind=C5=99ich=20Makovi=C4=8Dka?=" <makovick@gmail.com>,
       "Michael Ellerman" <michael@ellerman.id.au>
References: <g77CuMUl7QI.A.qMH.4ZpHMB@chimera>
In-Reply-To: <g77CuMUl7QI.A.qMH.4ZpHMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <rHrHQMIU4rI.A.5FD.vepHMB@chimera>
Subject: [Bug #15589] 2.6.34-rc1: Badness at fs/proc/generic.c:316
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 21 Jun 2010 00:32:12 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.33 and 2.6.34.

The following bug entry is on the current list of known regressions
introduced between 2.6.33 and 2.6.34.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15589
Subject		: 2.6.34-rc1: Badness at fs/proc/generic.c:316
Submitter	: Christian Kujau <lists@nerdbynature.de>
Date		: 2010-03-13 23:53 (100 days old)
Message-ID	: < <AANLkTikNcCtUn9SQwKu2b3IE6NiAwAhciHsm1HVH4EJh@mail.gmail.com>>
References	: http://marc.info/?l=linux-kernel&m=126852442903680&w=2
Handled-By	: Michael Ellerman <michael@ellerman.id.au>
		  Jindřich Makovička <makovick@gmail.com>
Patch		: http://patchwork.ozlabs.org/patch/52978/
		  http://lkml.indiana.edu/hypermail/linux/kernel/1006.0/00137.html


