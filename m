Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199Ab0GHX7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 19:59:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37933 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932177Ab0GHX66 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 19:58:58 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Paul Mackerras" <paulus@samba.org>
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera>
In-Reply-To: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <TXb9XdQzJoD.A.zxB.hMmNMB@chimera>
Subject: [Bug #16284] Hitting WARN_ON in hw_breakpoint code
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri,  9 Jul 2010 01:41:38 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.34.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16284
Subject		: Hitting WARN_ON in hw_breakpoint code
Submitter	: Paul Mackerras <paulus@samba.org>
Date		: 2010-06-23 12:57 (16 days old)
Message-ID	: <20100623125740.GA3368@brick.ozlabs.ibm.com>
References	: http://marc.info/?l=linux-kernel&m=127729789113432&w=2


