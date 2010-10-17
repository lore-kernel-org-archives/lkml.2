Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932848Ab0JQU0Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 16:26:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54554 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932818Ab0JQU0V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 16:26:21 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Miles Lane" <miles.lane@gmail.com>
References: <TP5BfCZNRXD.A._8.uj1uMB@chimera>
In-Reply-To: <TP5BfCZNRXD.A._8.uj1uMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <7N-qxsaxKCN.A.QaC.gk1uMB@chimera>
Subject: [Bug #19782] 2.6.36-rc6-git2 -- BUG dentry: Poison overwritten (after resume from hibernation)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 17 Oct 2010 22:21:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.35.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=19782
Subject		: 2.6.36-rc6-git2 -- BUG dentry: Poison overwritten (after resume from hibernation)
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2010-10-03 3:54 (15 days old)
Message-ID	: <AANLkTimrqtzBHAZSuDhEs_3CKA6pCbM35b1BtKH=MvC_@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=128607809314079&w=2


