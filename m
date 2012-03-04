Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab2CDUwX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 15:52:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54499 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755036Ab2CDUwV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 15:52:21 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
References: <FNlNbnGKWLP.A.dME.3F9UPB@chimera>
In-Reply-To: <FNlNbnGKWLP.A.dME.3F9UPB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <hq7dqombK_C.A.1gF.fG9UPB@chimera>
Subject: [Bug #42683] WARN... Device 'cpu1' does not have a release() function, it is broken and must be fixed. when doing 'xl vcpu-set <guest_id> 1'
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  4 Mar 2012 21:31:31 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 3.2.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: https://bugzilla.kernel.org/show_bug.cgi?id=42683
Subject		: WARN... Device 'cpu1' does not have a release() function, it is broken and must be fixed. when doing 'xl vcpu-set <guest_id> 1'
Submitter	: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date		: 2012-01-23 18:06 (42 days old)
Message-ID	: <20120123180601.GA24553@phenom.dumpdata.com>
References	: http://marc.info/?l=linux-kernel&m=132734233916154&w=2


