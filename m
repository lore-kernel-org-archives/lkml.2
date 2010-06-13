Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab0FMO74 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 10:59:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58945 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754546Ab0FMO7v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 10:59:51 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Corey Minyard" <cminyard@mvista.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Martin Wilck" <martin.wilck@ts.fujitsu.com>,
       "Thomas Jarosch" <thomas.jarosch@intra2net.com>
References: <g77CuMUl7QI.A.5wF.V5OFMB@chimera>
In-Reply-To: <g77CuMUl7QI.A.5wF.V5OFMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <YPGdyfWGvNK.A.nEG.i5OFMB@chimera>
Subject: [Bug #16147] ksoftirq hogs the CPU
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 13 Jun 2010 16:49:05 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.33 and 2.6.34.

The following bug entry is on the current list of known regressions
introduced between 2.6.33 and 2.6.34.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16147
Subject		: ksoftirq hogs the CPU
Submitter	: Thomas Jarosch <thomas.jarosch@intra2net.com>
Date		: 2010-06-07 15:17 (7 days old)
First-Bad-Commit: http://git.kernel.org/linus/ae74e823cb7d4cd476f623fce9a38f625f6c09a8
Handled-By	: Martin Wilck <martin.wilck@ts.fujitsu.com>
Patch		: https://bugzilla.kernel.org/attachment.cgi?id=26732


