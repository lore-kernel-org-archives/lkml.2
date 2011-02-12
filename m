Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab1BLXKU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 18:10:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39583 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753594Ab1BLXJ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 18:09:57 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
References: <NMZS1i37KEE.A.1eG.6_wVNB@chimera>
In-Reply-To: <NMZS1i37KEE.A.1eG.6_wVNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <8H3lez1sawF.A.5pG.IAxVNB@chimera>
Subject: [Bug #28842] 2.6.38-rc3 regression ipv6 TFTP download with curl failing in getpeername?
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 13 Feb 2011 00:05:22 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.37.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28842
Subject		: 2.6.38-rc3 regression ipv6 TFTP download with curl failing in getpeername?
Submitter	: Eric W. Biederman <ebiederm@xmission.com>
Date		: 2011-02-08 9:41 (5 days old)
Message-ID	: <m1ei7iamnn.fsf@fess.ebiederm.org>
References	: http://marc.info/?l=linux-kernel&m=129715811421534&w=2


