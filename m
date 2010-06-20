Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441Ab0FTWpi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 18:45:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58826 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757245Ab0FTWpS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 18:45:18 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Subrata Modak" <subrata@linux.vnet.ibm.com>
References: <g77CuMUl7QI.A.qMH.4ZpHMB@chimera>
In-Reply-To: <g77CuMUl7QI.A.qMH.4ZpHMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <rHrHQMIU4rI.A.lyB.9bpHMB@chimera>
Subject: [Bug #15936] Suspicious rcu_dereference_check() usage detected during 2.6.34-rc6 boot on PPC64/p5 processor
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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15936
Subject		: Suspicious rcu_dereference_check() usage detected during 2.6.34-rc6 boot on PPC64/p5 processor
Submitter	: Subrata Modak <subrata@linux.vnet.ibm.com>
Date		: 2010-05-06 7:29 (46 days old)
Message-ID	: <1273130279.4898.5.camel@subratamodak.linux.ibm.com>
References	: http://marc.info/?l=linux-kernel&m=127313031922395&w=2


