Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab0JJTW6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 15:22:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:32979 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859Ab0JJTW4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 15:22:56 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Jens Axboe" <jens.axboe@oracle.com>,
        "Maxim Levitsky" <maximlevitsky@gmail.com>,
        "Tejun Heo" <tj@kernel.org>
References: <pyPtebg28EI.A.ZPH.NvgsMB@chimera>
In-Reply-To: <pyPtebg28EI.A.ZPH.NvgsMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <yeAD7A8RDxC.A.btH.ivgsMB@chimera>
Subject: [Bug #18522] cdrom drive doesn't detect removal
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 10 Oct 2010 21:18:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.34 and 2.6.35.

The following bug entry is on the current list of known regressions
introduced between 2.6.34 and 2.6.35.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=18522
Subject		: cdrom drive doesn't detect removal
Submitter	: Maxim Levitsky <maximlevitsky@gmail.com>
Date		: 2010-09-12 9:49 (29 days old)
First-Bad-Commit: http://git.kernel.org/linus/6b4517a7913a09d3259bb1d21c9cb300f12294bd
Message-ID	: <1284284969.2928.18.camel@maxim-laptop>
References	: http://marc.info/?l=linux-kernel&m=128428499013930&w=2


