Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab0LEUlf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 15:41:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55374 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755645Ab0LEUfv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 15:35:51 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Miles Lane" <miles.lane@gmail.com>
References: <jyQ21do2hOF.A.qwD.m_--MB@chimera>
In-Reply-To: <jyQ21do2hOF.A.qwD.m_--MB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <z3LGq_ncuOB.A.SeF.aB_-MB@chimera>
Subject: [Bug #19782] 2.6.36-rc6-git2 -- BUG dentry: Poison overwritten (after resume from hibernation)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  5 Dec 2010 21:34:26 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.35 and 2.6.36.

The following bug entry is on the current list of known regressions
introduced between 2.6.35 and 2.6.36.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=19782
Subject		: 2.6.36-rc6-git2 -- BUG dentry: Poison overwritten (after resume from hibernation)
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2010-10-03 3:54 (64 days old)
Message-ID	: <AANLkTimrqtzBHAZSuDhEs_3CKA6pCbM35b1BtKH=MvC_@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=128607809314079&w=2


