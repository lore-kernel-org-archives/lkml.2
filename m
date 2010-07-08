Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759012Ab0GHX7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 19:59:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37965 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758998Ab0GHX7h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 19:59:37 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Miles Lane" <miles.lane@gmail.com>
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera>
In-Reply-To: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <TXb9XdQzJoD.A.m2.9LmNMB@chimera>
Subject: [Bug #16323] 2.6.35-rc3-git4 - kernel/sched.c:616 invoked rcu_dereference_check() without protection!
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri,  9 Jul 2010 01:41:42 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.34.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16323
Subject		: 2.6.35-rc3-git4 - kernel/sched.c:616 invoked rcu_dereference_check() without protection!
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2010-07-01 12:21 (8 days old)
Message-ID	: <AANLkTini6hz2LFeZi8CMUmY3xw1MU7NxmyesuxZ4oCdo@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=127798693125541&w=2


