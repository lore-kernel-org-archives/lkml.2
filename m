Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344Ab0FTWpV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 18:45:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58823 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757145Ab0FTWpQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 18:45:16 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Miles Lane" <miles.lane@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
References: <g77CuMUl7QI.A.qMH.4ZpHMB@chimera>
In-Reply-To: <g77CuMUl7QI.A.qMH.4ZpHMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <rHrHQMIU4rI.A.E9B.QcpHMB@chimera>
Subject: [Bug #15863] 2.6.34-rc5-git7 (plus all patches) -- another suspicious rcu_dereference_check() usage.
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 21 Jun 2010 00:34:25 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.33 and 2.6.34.

The following bug entry is on the current list of known regressions
introduced between 2.6.33 and 2.6.34.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15863
Subject		: 2.6.34-rc5-git7 (plus all patches) -- another suspicious rcu_dereference_check() usage.
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2010-04-27 0:51 (55 days old)
Message-ID	: <h2ya44ae5cd1004261751waa5cb65ei3d139cbcfa2cc5cf@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=127232949104878&w=2
Handled-By	: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Patch		: https://patchwork.kernel.org/patch/96096/


