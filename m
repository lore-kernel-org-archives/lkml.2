Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab1H1TFC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 15:05:02 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43410 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922Ab1H1TEo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 15:04:44 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Witold Baryluk" <baryluk@smp.if.uj.edu.pl>
References: <lx6sezwGldO.A.IhF.UBpWOB@chimera>
In-Reply-To: <lx6sezwGldO.A.IhF.UBpWOB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <sfuyzWlorBN.A.JzF.hBpWOB@chimera>
Subject: [Bug #41442] rcu_sched_state detected stall on CPU 0, when booting on Xen
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 28 Aug 2011 20:22:11 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 3.0.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=41442
Subject		: rcu_sched_state detected stall on CPU 0, when booting on Xen
Submitter	: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Date		: 2011-08-21 04:06 (8 days old)


