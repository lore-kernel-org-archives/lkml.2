Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932551Ab0IZVAK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 17:00:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43140 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932443Ab0IZVAF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 17:00:05 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Jens Axboe" <jens.axboe@oracle.com>,
        "Maxim Levitsky" <maximlevitsky@gmail.com>,
        "Tejun Heo" <tj@kernel.org>
References: <onxdOCF6lb.A.vKB.a_6nMB@chimera>
In-Reply-To: <onxdOCF6lb.A.vKB.a_6nMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <UfOptYFtL6C.A.bOC.GA7nMB@chimera>
Subject: [Bug #18522] [REGRESSION] cdrom drive doesn't detect removal
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 26 Sep 2010 22:33:18 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.34 and 2.6.35.

The following bug entry is on the current list of known regressions
introduced between 2.6.34 and 2.6.35.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=18522
Subject		: [REGRESSION] cdrom drive doesn't detect removal
Submitter	: Maxim Levitsky <maximlevitsky@gmail.com>
Date		: 2010-09-12 9:49 (15 days old)
First-Bad-Commit: http://git.kernel.org/linus/6b4517a7913a09d3259bb1d21c9cb300f12294bd
Message-ID	: <1284284969.2928.18.camel@maxim-laptop>
References	: http://marc.info/?l=linux-kernel&m=128428499013930&w=2


