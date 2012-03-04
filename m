Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab2CDUwd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 15:52:33 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54531 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755531Ab2CDUwa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 15:52:30 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "James Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Matt Carlson" <mcarlson@broadcom.com>
References: <FNlNbnGKWLP.A.dME.3F9UPB@chimera>
In-Reply-To: <FNlNbnGKWLP.A.dME.3F9UPB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <hq7dqombK_C.A.rUF.ZG9UPB@chimera>
Subject: [Bug #42707] Hang deconfiguring network interface (in shutdown) on 3.3-rc1
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


Bug-Entry	: https://bugzilla.kernel.org/show_bug.cgi?id=42707
Subject		: Hang deconfiguring network interface (in shutdown) on 3.3-rc1
Submitter	: James Bottomley <James.Bottomley@hansenpartnership.com>
Date		: 2012-01-28 19:56 (37 days old)
First-Bad-Commit: http://git.kernel.org/linus/92feeabf3f673767c6ee4cfc7fc224098446c1c1
Message-ID	: <1327780565.2924.24.camel@dabdike.int.hansenpartnership.com>
References	: http://marc.info/?l=linux-kernel&m=132778076214873&w=2


